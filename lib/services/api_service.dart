import 'package:dio/dio.dart';
import 'package:travel_suite/services/secure_token_service.dart';
import 'dio_error_handler.dart';
// import 'api_exceptions.dart';


class NetworkManager {
  late Dio _dio;
  final SecureStorageService _storage = SecureStorageService();
  
  NetworkManager() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.annexindiatour.com/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await _storage.getAccessToken();
        // print('accessToken: $accessToken');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired -> Refresh token
            String? refreshToken = await _storage.getRefreshToken();

            if (refreshToken != null) {
              try {
                Response response = await _dio.post(
                  "/refresh-token",
                  data: {"refreshToken": refreshToken},
                );

                String newAccessToken = response.data["accessToken"];
                String newRefreshToken = response.data["refreshToken"];

                await _storage.saveTokens(
                    newAccessToken, newRefreshToken);

                // Retry original request
                final requestOptions = error.requestOptions;
                requestOptions.headers["Authorization"] =
                    "Bearer $newAccessToken";

                final clonedRequest =
                    await _dio.fetch(requestOptions);

                return handler.resolve(clonedRequest);
              } catch (e) {
                await _storage.clearTokens();
              }
            }
          }
        return handler.next(error);
      },
    ));
  } 
  // final Dio _dio = Dio(
  //   BaseOptions(
  //     baseUrl: 'https://www.annexindiatour.com/api',
  //     connectTimeout: const Duration(seconds: 30),
  //     receiveTimeout: const Duration(seconds: 30),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   ),
    
  // );

  // Future<Map<String, dynamic>> requestOTP(String identifier, String password) async {
  //   try {
  //     Response response = await _dio.post(
  //       '/employee/login/request-otp/', 
  //       data: {
  //         'identifier': identifier,
  //         'password': password,
  //       },
  //     );  
  //     return response.data; // API response as Map
  //   } on DioException catch (e) {
  //     throw DioErrorHandler.handleError(e);
  //   }
  // }

  // Future<Map<String, dynamic>> validateOTP(String identifier,String otp) async {
  //   try {
  //     Response response = await _dio.post(
  //       '/employee/login/validate_otp/', 
  //       data: {
  //         'identifier': identifier,
  //         'otp': otp,
  //       },
  //     );      
  //     if (response.statusCode == 200) {
  //       return response.data; // API response as Map
  //     } else {
  //       throw Exception('Failed to Validate OTP: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     throw _handleDioError(e);
  //   }
  // }

  Future<Response<T>> getRequest<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleError(e);
    }
  }

  Future<Response> post(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw DioErrorHandler.handleError(e);
    }
  }
   
  // Exception _handleDioError(DioException e) {
  //   if (e.response != null) {
  //     return Exception(
  //       e.response?.data['message'] ?? 'Server error',
  //     );
  //   } else {
  //     return Exception('Network error');
  //   }
  // }
}
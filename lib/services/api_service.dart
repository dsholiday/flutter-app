import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.annexindiatour.com/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> requestOTP(String identifier, String password) async {
    try {
      Response response = await _dio.post(
        '/employee/login/request-otp/', 
        data: {
          'identifier': identifier,
          'password': password,
        },
      );      
      if (response.statusCode == 200) {
        return response.data; // API response as Map
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Server returned an error
        throw Exception('Error: ${e.response?.data}');
      } else {
        // Something else happened
        throw Exception('Error sending request: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> validateOTP(String identifier,String otp) async {
    try {
      Response response = await _dio.post(
        '/employee/login/validate_otp/', 
        data: {
          'identifier': identifier,
          'otp': otp,
        },
      );      
      if (response.statusCode == 200) {
        return response.data; // API response as Map
      } else {
        throw Exception('Failed to Validate OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Server returned an error
        throw Exception('Error: ${e.response?.data}');
      } else {
        // Something else happened
        throw Exception('Error sending request: ${e.message}');
      }
    }
  }
}
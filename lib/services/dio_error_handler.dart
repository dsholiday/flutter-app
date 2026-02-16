import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class DioErrorHandler {
  static ApiException handleError(DioException error) {
    switch (error.type) {

      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timeout");

      case DioExceptionType.sendTimeout:
        return ApiException("Send timeout");

      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout");

      case DioExceptionType.connectionError:
        return ApiException("No Internet Connection");

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode, error.response?.data);

      case DioExceptionType.cancel:
        return ApiException("Request cancelled");

      case DioExceptionType.unknown:
      default:
        return ApiException("Unexpected error occurred");
    }
  }

  static ApiException _handleStatusCode(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return ApiException(data?['error'] ?? "Bad Request");

      case 401:
        return ApiException(data?['error'] ?? "Unauthorized");

      case 403:
        return ApiException("Forbidden");

      case 404:
        return ApiException("Not Found");

      case 500:
        return ApiException("Internal Server Error");

      default:
        return ApiException("Something went wrong ($statusCode)");
    }
  }
}
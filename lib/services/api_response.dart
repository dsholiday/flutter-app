class ApiResponse<T> {
  // final bool success;
  // final String message;
  final T data;

  ApiResponse({
    // required this.success,
    // required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse(
      // success: json['success'],
      // message: json['message'],
      data: fromJsonT(json['results']),
    );
  }
}
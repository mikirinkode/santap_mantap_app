// TODO: REMOVE DUE TO UNUSED
class ApiResponse<T> {
  final bool error;
  final String message;
  final T? data;

  ApiResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse(
      error: json['error'],
      message: json['message'],
      data: json.containsKey('restaurant') || json.containsKey('restaurants')
          ? fromJson(json)
          : null,
    );
  }
}

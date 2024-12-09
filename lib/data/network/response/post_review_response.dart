class PostReviewResponse {
  final bool error;
  final String message;

  PostReviewResponse({required this.error, required this.message});

  factory PostReviewResponse.fromJson(Map<String, dynamic> json) {
    return PostReviewResponse(error: json['error'], message: json['message']);
  }
}

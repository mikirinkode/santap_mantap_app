class CustomerReviewModel {
  final String? name;
  final String? review;
  final String? date;

  CustomerReviewModel({
    this.name,
    this.review,
    this.date,
  });

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) {
    return CustomerReviewModel(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}

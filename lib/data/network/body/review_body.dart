import '../../../domain/entities/review_entity.dart';

class ReviewBody {
  final String restaurantId;
  final String name;
  final String review;

  ReviewBody({
    required this.restaurantId,
    required this.name,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
        "id": restaurantId,
        "name": name,
        "review": review,
      };

  factory ReviewBody.fromEntity(ReviewEntity review) => ReviewBody(
        restaurantId: review.restaurantId,
        name: review.name,
        review: review.review,
      );
}

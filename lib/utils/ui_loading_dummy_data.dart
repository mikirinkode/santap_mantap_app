import 'package:santap_mantap_app/domain/entities/customer_review_entity.dart';
import 'package:santap_mantap_app/domain/entities/menu_entity.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';

class UiLoadingDummyData {
  UiLoadingDummyData._();

  static const String shortDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit";

  static const String description =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

  static MenuEntity dummyMenu = MenuEntity(
    foods: [
      MenuItemEntity(name: "Dummy"),
      MenuItemEntity(name: "Dummy"),
      MenuItemEntity(name: "Dummy"),
    ],
    drinks: [
      MenuItemEntity(name: "Dummy"),
      MenuItemEntity(name: "Dummy"),
      MenuItemEntity(name: "Dummy"),
    ],
  );

  static List<CustomerReviewEntity> dummyCustomerReviews = [
    CustomerReviewEntity(
      name: "Dummy",
      review: shortDescription,
    ),
    CustomerReviewEntity(
      name: "Dummy",
      review: shortDescription,
    ),
    CustomerReviewEntity(
      name: "Dummy",
      review: shortDescription,
    ),
  ];

  static RestaurantEntity dummyRestaurant = const RestaurantEntity(
    name: "Dummy Restaurant",
    rating: 4.5,
    city: "Dummy",
    id: "dummy-id",
    description: "",
    pictureId: "",
    pictureUrl: "",
  );

  static List<RestaurantEntity> dummyRestaurants = [
    dummyRestaurant,
    dummyRestaurant,
    dummyRestaurant,
  ];
}

import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';

class DummyData {
  DummyData._();

  static final List<RestaurantEntity> restaurantList = [
    RestaurantEntity(
      id: "1",
      name: "name",
      description: "description",
      city: "city",
      pictureId: "pictureId",
      rating: 1.0,
      pictureUrl: "pictureUrl",
    ),
    RestaurantEntity(
      id: "2",
      name: "name",
      description: "description",
      city: "city",
      pictureId: "pictureId",
      rating: 2.0,
      pictureUrl: "pictureUrl",
    ),
    RestaurantEntity(
      id: "3",
      name: "name",
      description: "description",
      city: "city",
      pictureId: "pictureId",
      rating: 3.0,
      pictureUrl: "pictureUrl",
    ),
    RestaurantEntity(
      id: "4",
      name: "name",
      description: "description",
      city: "city",
      pictureId: "pictureId",
      rating: 4.0,
      pictureUrl: "pictureUrl",
    ),
    RestaurantEntity(
      id: "5",
      name: "name",
      description: "description",
      city: "city",
      pictureId: "pictureId",
      rating: 5.0,
      pictureUrl: "pictureUrl",
    ),
  ];
}

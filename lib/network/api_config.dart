class ApiConfig {
  ApiConfig._();
  
  static const baseURL = "https://restaurant-api.dicoding.dev/";
  static const restaurantListURL = "$baseURL/list";

  static String restaurantDetailURL(String id) => "$baseURL/detail/$id";
  static String smallImageURL(String pictureId) => "$baseURL/images/small/$pictureId";
  static String mediumImageURL(String pictureId) => "$baseURL/images/medium/$pictureId";
  static String largeImageURL(String pictureId) => "$baseURL/images/large/$pictureId";
}

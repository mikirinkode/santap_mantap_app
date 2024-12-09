class ApiConfig {
  ApiConfig._();
  
  static const baseURL = "https://restaurant-api.dicoding.dev";
  static const restaurantListURL = "$baseURL/list";
  static const restaurantDetailURL = "$baseURL/detail";
  static const searchURL = "$baseURL/search";

  static String smallImageURL(String pictureId) => "$baseURL/images/small/$pictureId";
  static String mediumImageURL(String pictureId) => "$baseURL/images/medium/$pictureId";
  static String largeImageURL(String pictureId) => "$baseURL/images/large/$pictureId";
}

enum NavigationRoute {
  mainRoute("/main"),
  detailRoute("/detail"),
  favoriteRoute("/favorite"),
  settingRoute("/favorite"),
  searchRoute("/search");

  const NavigationRoute(this.name);
  final String name;
}

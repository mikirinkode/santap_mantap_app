enum NavigationRoute {
  mainRoute("/main"),
  detailRoute("/detail"),
  favoriteRoute("/favorite"),
  settingRoute("/setting"),
  searchRoute("/search");

  const NavigationRoute(this.name);
  final String name;
}

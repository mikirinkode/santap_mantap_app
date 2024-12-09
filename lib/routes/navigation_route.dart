enum NavigationRoute {
  mainRoute("/main"),
  detailRoute("/detail"),
  searchRoute("/search");

  const NavigationRoute(this.name);
  final String name;
}

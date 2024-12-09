class MenuEntity {
  final List<MenuItemEntity>? foods;
  final List<MenuItemEntity>? drinks;

  MenuEntity({this.foods, this.drinks});
}

class MenuItemEntity {
  final String? name;

  MenuItemEntity({this.name});
}

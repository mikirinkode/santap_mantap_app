class MenuModel {
  final List<MenuItemModel>? foods;
  final List<MenuItemModel>? drinks;

  MenuModel({this.foods, this.drinks});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      foods: (json['foods'] as List?)
          ?.map((item) => MenuItemModel.fromJson(item))
          .toList(),
      drinks: (json['drinks'] as List?)
          ?.map((item) => MenuItemModel.fromJson(item))
          .toList(),
    );
  }
}

class MenuItemModel {
  final String? name;

  MenuItemModel({this.name});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(name: json['name']);
  }
}

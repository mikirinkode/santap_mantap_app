import 'package:santap_mantap_app/domain/entities/menu_entity.dart';

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

  MenuEntity toEntity() => MenuEntity(
        foods: foods?.map((item) => item.toEntity()).toList(),
        drinks: drinks?.map((item) => item.toEntity()).toList(),
      );
}

class MenuItemModel {
  final String? name;

  MenuItemModel({this.name});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(name: json['name']);
  }

  MenuItemEntity toEntity() => MenuItemEntity(name: name);
}

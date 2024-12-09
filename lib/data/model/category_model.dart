import 'package:santap_mantap_app/domain/entities/category_entity.dart';

class CategoryModel {
  final String? name;

  CategoryModel({this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(name: json['name']);
  }

  CategoryEntity toEntity() => CategoryEntity(name: name);
}

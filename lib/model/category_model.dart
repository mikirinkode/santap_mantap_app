class CategoryModel {
  final String? name;

  CategoryModel({this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(name: json['name']);
  }
}

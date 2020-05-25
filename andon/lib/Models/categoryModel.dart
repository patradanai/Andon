class CategoryModel {
  int id;
  String machine;
  String zone;

  CategoryModel({this.id, this.machine, this.zone});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'], machine: json['machine'], zone: json['zone']);
  }
}

class CategoryModel {
  String? categoryId;
  String? name;
  String? description;
  bool? isActive;

  CategoryModel({
    this.categoryId,
    this.name,
    this.description,
    this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json["category_id"],
      name: json["name"],
      description: json["description"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "name": name,
      "description": description,
      "is_active": isActive,
    };
  }
}

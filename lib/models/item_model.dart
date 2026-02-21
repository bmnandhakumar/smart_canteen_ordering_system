class ItemModel {
  String? itemId;
  String? categoryId;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  int? stockQuantity;
  bool? isAvailable;
  DateTime? createdAt;
  DateTime? updatedAt;

  ItemModel({
    this.itemId,
    this.categoryId,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.stockQuantity,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemId: json["item_id"],
      categoryId: json["category_id"],
      name: json["name"],
      description: json["description"],
      price: (json["price"] as num?)?.toDouble(),
      imageUrl: json["image_url"],
      stockQuantity: json["stock_quantity"],
      isAvailable: json["is_available"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item_id": itemId,
      "category_id": categoryId,
      "name": name,
      "description": description,
      "price": price,
      "image_url": imageUrl,
      "stock_quantity": stockQuantity,
      "is_available": isAvailable,
    };
  }
}

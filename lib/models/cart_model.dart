class CartItemModel {
  final String itemId;
  final int quantity;

  const CartItemModel({
    required this.itemId,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json["item_id"] as String,
      quantity: (json["quantity"] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "quantity": quantity,
  };

  CartItemModel copyWith({String? itemId, int? quantity}) {
    return CartItemModel(
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartModel {
  final String cartId;
  final String userId;
  final List<CartItemModel> items;
  final DateTime? updatedAt;

  const CartModel({
    required this.cartId,
    required this.userId,
    required this.items,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json["items"] as List<dynamic>? ?? [];
    return CartModel(
      cartId: json["cart_id"] as String? ?? "",
      userId: json["user_id"] as String? ?? "",
      items: rawItems
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "user_id": userId,
    "items": items.map((e) => e.toJson()).toList(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  /// Total number of individual units across all cart items
  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  /// Convenience: find quantity for a specific itemId (0 if not in cart)
  int quantityOf(String itemId) {
    try {
      return items.firstWhere((e) => e.itemId == itemId).quantity;
    } catch (_) {
      return 0;
    }
  }

  CartModel copyWith({
    String? cartId,
    String? userId,
    List<CartItemModel>? items,
    DateTime? updatedAt,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
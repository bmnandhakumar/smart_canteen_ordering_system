class OrderItem {
  final String itemId;
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json["item_id"] as String? ?? "",
      name: json["name"] as String? ?? "",
      quantity: (json["quantity"] as num?)?.toInt() ?? 0,
      price: (json["price"] as num?)?.toDouble() ??
             (json["price_at_time"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "name": name,
    "quantity": quantity,
    "price": price,
  };

  double get total => price * quantity;

  OrderItem copyWith({
    String? itemId,
    String? name,
    int? quantity,
    double? price,
  }) {
    return OrderItem(
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  completed,
  cancelled,
  notReceived,
  received,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.confirmed:
        return "Confirmed";
      case OrderStatus.preparing:
        return "Preparing";
      case OrderStatus.ready:
        return "Ready";
      case OrderStatus.completed:
        return "Completed";
      case OrderStatus.cancelled:
        return "Cancelled";
      case OrderStatus.notReceived:
        return "Not Received";
      case OrderStatus.received:
        return "Received";
    }
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return OrderStatus.pending;
      case "confirmed":
        return OrderStatus.confirmed;
      case "preparing":
        return OrderStatus.preparing;
      case "ready":
        return OrderStatus.ready;
      case "completed":
        return OrderStatus.completed;
      case "cancelled":
        return OrderStatus.cancelled;
      case "not_received":
        return OrderStatus.notReceived;
      case "received":
        return OrderStatus.received;
      default:
        return OrderStatus.pending;
    }
  }
}

class OrderModel {
  final String orderId;
  final String? userId;
  final List<OrderItem>? items;
  final double? totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final int estimatedPrepTime;
  final int? tokenNumber;

  const OrderModel({
    required this.orderId,
    this.userId,
    this.items,
    this.totalAmount,
    required this.status,
    required this.createdAt,
    this.estimatedPrepTime = 15,
    this.tokenNumber,
  });

  /// Create OrderModel from placeOrder API response (minimal fields)
  factory OrderModel.fromPlaceOrderResponse(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json["order_id"] as String? ?? "",
      status: OrderStatusExtension.fromString(json["status"] as String? ?? "confirmed"),
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"] as String)
          : DateTime.now(),
      estimatedPrepTime: (json["estimated_prep_time"] as num?)?.toInt() ?? 15,
      tokenNumber: (json["token_number"] as num?)?.toInt(),
      // These fields are NOT in the placeOrder response
      userId: null,
      items: null,
      totalAmount: null,
    );
  }

  /// Create OrderModel from full order data (getOrders API)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json["items"] as List<dynamic>?;
    return OrderModel(
      orderId: json["order_id"] as String? ?? "",
      userId: json["user_id"] as String?,
      items: rawItems != null
          ? rawItems
              .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      totalAmount: (json["total_amount"] as num?)?.toDouble(),
      status: OrderStatusExtension.fromString(json["status"] as String? ?? json["order_status"] as String? ?? "pending"),
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"] as String)
          : (json["ordered_at"] != null
              ? DateTime.parse(json["ordered_at"] as String)
              : DateTime.now()),
      estimatedPrepTime: (json["estimated_prep_time"] as num?)?.toInt() ?? 15,
      tokenNumber: (json["token_number"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    if (userId != null) "user_id": userId,
    if (items != null) "items": items!.map((e) => e.toJson()).toList(),
    if (totalAmount != null) "total_amount": totalAmount,
    "status": status.displayName.toLowerCase(),
    "created_at": createdAt.toIso8601String(),
    "estimated_prep_time": estimatedPrepTime,
    if (tokenNumber != null) "token_number": tokenNumber,
  };

  OrderModel copyWith({
    String? orderId,
    String? userId,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    int? estimatedPrepTime,
    int? tokenNumber,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedPrepTime: estimatedPrepTime ?? this.estimatedPrepTime,
      tokenNumber: tokenNumber ?? this.tokenNumber,
    );
  }

  /// Format order ID for display (e.g., "#ORD-2401")
  String get displayId {
    final len = orderId.length > 6 ? 6 : orderId.length;
    return "#ORD-${orderId.substring(0, len).toUpperCase()}";
  }

  /// Check if this is a minimal order (from placeOrder response)
  bool get isMinimal => userId == null || items == null;
}

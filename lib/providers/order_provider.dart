import "package:flutter/material.dart";
import "../models/order_model.dart";
import "../services/order_service.dart";

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService.instance;

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // For order placement
  bool _isPlacingOrder = false;
  String? _placeOrderError;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  bool get isPlacingOrder => _isPlacingOrder;
  String? get placeOrderError => _placeOrderError;

  // Get orders by status - mapped to backend statuses
  // Backend has: "not_received" and "received"
  List<OrderModel> get activeOrders => _orders
      .where((o) =>
          o.status == OrderStatus.notReceived ||
          o.status == OrderStatus.confirmed ||
          o.status == OrderStatus.preparing ||
          o.status == OrderStatus.ready)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<OrderModel> get completedOrders => _orders
      .where((o) =>
          o.status == OrderStatus.received ||
          o.status == OrderStatus.completed)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<OrderModel> get cancelledOrders => _orders
      .where((o) => o.status == OrderStatus.cancelled)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  /// Load all orders for a user
  Future<void> loadOrders(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _orders = await _service.getOrders(userId: userId);
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Place a new order
  /// Returns the created order on success
  Future<OrderModel?> placeOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    _isPlacingOrder = true;
    _placeOrderError = null;
    notifyListeners();

    try {
      final order = await _service.placeOrder(
        userId: userId,
        items: items,
        totalAmount: totalAmount,
      );

      // Add to orders list
      _orders.insert(0, order);
      _placeOrderError = null;

      return order;
    } catch (e) {
      _placeOrderError = e.toString();
      return null;
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }

  /// Refresh orders from server
  Future<void> refreshOrders(String userId) async {
    await loadOrders(userId);
  }

  /// Get a specific order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearPlaceOrderError() {
    _placeOrderError = null;
    notifyListeners();
  }
}

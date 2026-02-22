import "package:flutter/material.dart";
import "../models/cart_model.dart";
import "../models/item_model.dart";
import "../services/cart_service.dart";

class CartProvider extends ChangeNotifier {
  CartProvider();

  final CartService _service = CartService();

  CartModel? _cart;
  bool _isLoading = false;
  bool _hasError = false;

  final Map<String, ItemModel> _itemCache = {};

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// Total number of units in the cart (badge count)
  int get totalQuantity => _cart?.totalQuantity ?? 0;

  /// Total item count (unique lines)
  int get itemCount => _cart?.items.length ?? 0;

  /// Whether the cart has any items
  bool get isEmpty => (_cart?.items.isEmpty) ?? true;

  /// Quantity of a specific item currently in the cart
  int quantityOf(String itemId) => _cart?.quantityOf(itemId) ?? 0;

  /// Read-only access to the item cache (itemId → ItemModel).
  /// Used by CartScreen to resolve name/price/imageUrl for display.
  Map<String, ItemModel> get itemCache => Map.unmodifiable(_itemCache);

  /// Total price based on cached ItemModel prices
  double get totalPrice {
    if (_cart == null) return 0;
    double total = 0;
    for (final cartItem in _cart!.items) {
      final item = _itemCache[cartItem.itemId];
      if (item != null) {
        total += (item.price ?? 0) * cartItem.quantity;
      }
    }
    return total;
  }

  /// Call this from ItemsScreen after loading items so the provider
  /// can compute prices without an extra API call.
  void cacheItems(List<ItemModel> items) {
    for (final item in items) {
      if (item.itemId != null) {
        _itemCache[item.itemId!] = item;
      }
    }
    notifyListeners();
  }


  Future<void> loadCart() async {
    _setLoading(true);
    final result = await _service.getCart();
    _cart = result;
    _hasError = result == null;
    _setLoading(false);
  }


  Future<void> addItem(String userId,String itemId) async {
    final newQty = 1;

    final result = await _service.addItem(userId: userId,itemId: itemId, quantity: newQty);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }

  Future<void> decrementItem(String userId,String itemId) async {
    final result = await _service.removeItem(userId: userId,itemId: itemId);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }

  Future<void> removeItem(String userId, String itemId) async {
    final result = await _service.removeItem(userId: userId ,itemId: itemId);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }

  Future<void> deleteAllItems(String userId)async {
    final result = await _service.deleteAllItems(userId:userId);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

}
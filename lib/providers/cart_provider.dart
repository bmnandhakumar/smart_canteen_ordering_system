import "package:flutter/material.dart";
import "../models/cart_model.dart";
import "../models/item_model.dart";
import "../services/cart_service.dart";

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();

  CartModel? _cart;
  bool _isLoading = false;
  bool _hasError = false;

  final Map<String, ItemModel> _itemCache = {};

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  int get totalQuantity => _cart?.totalQuantity ?? 0;
  int get itemCount => _cart?.items.length ?? 0;
  bool get isEmpty => (_cart?.items.isEmpty) ?? true;

  Map<String, ItemModel> get itemCache => Map.unmodifiable(_itemCache);

  double get totalPrice {
    if (_cart == null) return 0;

    double total = 0;

    for (final cartItem in _cart!.items) {
      final item = _itemCache[cartItem.itemId];
      if (item == null) continue;

      total += (item.price ?? 0) * cartItem.quantity;
    }

    return total;
  }

  int quantityOf(String itemId) => _cart?.quantityOf(itemId) ?? 0;

  Future<void> loadCart(String userId) async {
    _setLoading(true);

    final result = await _service.getCart(userId: userId);

    if (result == null) {
      _hasError = true;
      _setLoading(false);
      return;
    }

    _cart = result;
    _hasError = false;

    await _hydrateItemDetails();

    _setLoading(false);
  }

  Future<void> _hydrateItemDetails() async {
    if (_cart == null || _cart!.items.isEmpty) return;

    final itemIds = _cart!.items.map((e) => e.itemId).toList();

    final items = await _service.getItemsByIds(itemIds);

    _itemCache.clear();

    for (final item in items) {
      if (item.itemId == null) continue;
      _itemCache[item.itemId!] = item;
    }

    notifyListeners();
  }

  Future<void> addItem(String userId, String itemId) async {
    final result =
    await _service.addItem(userId: userId, itemId: itemId, quantity: 1);

    if (result == null) return;

    _cart = result;

    await _hydrateItemDetails();

    notifyListeners();
  }

  Future<void> decrementItem(String userId, String itemId) async {
    final result =
    await _service.removeItem(userId: userId, itemId: itemId);

    if (result == null) return;

    _cart = result;

    await _hydrateItemDetails();

    notifyListeners();
  }

  Future<void> removeItem(String userId, String itemId) async {
    final result =
    await _service.removeItem(userId: userId, itemId: itemId);

    if (result == null) return;

    _cart = result;

    await _hydrateItemDetails();

    notifyListeners();
  }

  Future<void> deleteAllItems(String userId) async {
    final result =
    await _service.deleteAllItems(userId: userId);

    if (result == null) return;

    _cart = result;
    _itemCache.clear();

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
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

  int get totalQuantity => _cart?.totalQuantity ?? 0;

  int get itemCount => _cart?.items.length ?? 0;

  bool get isEmpty => (_cart?.items.isEmpty) ?? true;

  Map<String,ItemModel> get itemCache => _itemCache;


  int quantityOf(String itemId) => _cart?.quantityOf(itemId) ?? 0;

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


  Future<void> addItem(String itemId) async {
    final newQty = quantityOf(itemId) + 1;
    _optimisticUpdate(itemId, newQty);

    final result = await _service.addItem(itemId: itemId, quantity: newQty);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }


  Future<void> decrementItem(String itemId) async {
    final current = quantityOf(itemId);
    if (current <= 0) return;

    if (current == 1) {
      await removeItem(itemId);
      return;
    }

    final newQty = current - 1;
    _optimisticUpdate(itemId, newQty);

    final result = await _service.addItem(itemId: itemId, quantity: newQty);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }

  Future<void> removeItem(String itemId) async {
    // Optimistic: remove locally
    if (_cart != null) {
      _cart = _cart!.copyWith(
        items: _cart!.items.where((e) => e.itemId != itemId).toList(),
      );
      notifyListeners();
    }

    final result = await _service.removeItem(itemId: itemId);
    if (result != null) {
      _cart = result;
      notifyListeners();
    }
  }



  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _optimisticUpdate(String itemId, int newQty) {
    if (_cart == null) return;

    final existingIndex =
    _cart!.items.indexWhere((e) => e.itemId == itemId);

    List<CartItemModel> updatedItems = List.from(_cart!.items);

    if (existingIndex >= 0) {
      updatedItems[existingIndex] =
          updatedItems[existingIndex].copyWith(quantity: newQty);
    } else {
      updatedItems.add(CartItemModel(itemId: itemId, quantity: newQty));
    }

    _cart = _cart!.copyWith(items: updatedItems);
    notifyListeners();
  }
}
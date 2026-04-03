import "package:flutter/material.dart";
import "../models/order_model.dart";
import "../models/category_model.dart";
import "../models/item_model.dart";
import "../models/user_model.dart";
import "../services/admin_service.dart";

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService.instance;

  // Dashboard stats
  int _totalOrdersToday = 0;
  double _totalRevenueToday = 0;
  int _activeOrders = 0;
  int _lowStockItems = 0;
  bool _isLoadingStats = false;
  String? _statsError;

  // All orders (admin view)
  List<OrderModel> _allOrders = [];
  bool _isLoadingOrders = false;
  String? _ordersError;

  // All users
  List<UserModel> _allUsers = [];
  bool _isLoadingUsers = false;
  String? _usersError;

  // All categories
  List<CategoryModel> _allCategories = [];
  bool _isLoadingCategories = false;
  String? _categoriesError;

  // All items
  List<ItemModel> _allItems = [];
  bool _isLoadingItems = false;
  String? _itemsError;

  // Getters
  int get totalOrdersToday => _totalOrdersToday;
  double get totalRevenueToday => _totalRevenueToday;
  int get activeOrders => _activeOrders;
  int get lowStockItems => _lowStockItems;
  bool get isLoadingStats => _isLoadingStats;
  String? get statsError => _statsError;

  List<OrderModel> get allOrders => List.unmodifiable(_allOrders);
  bool get isLoadingOrders => _isLoadingOrders;
  String? get ordersError => _ordersError;

  List<UserModel> get allUsers => List.unmodifiable(_allUsers);
  bool get isLoadingUsers => _isLoadingUsers;
  String? get usersError => _usersError;

  List<CategoryModel> get allCategories => List.unmodifiable(_allCategories);
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoriesError => _categoriesError;

  List<ItemModel> get allItems => List.unmodifiable(_allItems);
  bool get isLoadingItems => _isLoadingItems;
  String? get itemsError => _itemsError;

  /// Load dashboard statistics
  Future<void> loadDashboardStats() async {
    _isLoadingStats = true;
    _statsError = null;
    notifyListeners();

    try {
      final stats = await _service.getDashboardStats();
      _totalOrdersToday = stats['total_orders_today'] ?? 0;
      _totalRevenueToday = (stats['total_revenue_today'] ?? 0).toDouble();
      _activeOrders = stats['active_orders'] ?? 0;
      _lowStockItems = stats['low_stock_items'] ?? 0;
      _statsError = null;
    } catch (e) {
      _statsError = e.toString();
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  /// Load all orders for admin
  Future<void> loadAllOrders() async {
    _isLoadingOrders = true;
    _ordersError = null;
    notifyListeners();

    try {
      _allOrders = await _service.getAllOrders();
      _ordersError = null;
    } catch (e) {
      _ordersError = e.toString();
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await _service.updateOrderStatus(orderId, status);
      // Refresh orders after update
      await loadAllOrders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load all categories
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    _categoriesError = null;
    notifyListeners();

    try {
      _allCategories = await _service.getAllCategories();
      _categoriesError = null;
    } catch (e) {
      _categoriesError = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Create category
  Future<bool> createCategory(String name, String description) async {
    try {
      await _service.createCategory(name, description);
      await loadCategories();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update category
  Future<bool> updateCategory(String categoryId, String name, String description) async {
    try {
      await _service.updateCategory(categoryId, name, description);
      await loadCategories();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _service.deleteCategory(categoryId);
      await loadCategories();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load all items
  Future<void> loadItems() async {
    _isLoadingItems = true;
    _itemsError = null;
    notifyListeners();

    try {
      _allItems = await _service.getAllItems();
      _itemsError = null;
    } catch (e) {
      _itemsError = e.toString();
    } finally {
      _isLoadingItems = false;
      notifyListeners();
    }
  }

  /// Create item
  Future<bool> createItem(Map<String, dynamic> itemData) async {
    try {
      await _service.createItem(itemData);
      await loadItems();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update item
  Future<bool> updateItem(String itemId, Map<String, dynamic> itemData) async {
    try {
      await _service.updateItem(itemId, itemData);
      await loadItems();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete item
  Future<bool> deleteItem(String itemId) async {
    try {
      await _service.deleteItem(itemId);
      await loadItems();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load all users
  Future<void> loadUsers() async {
    _isLoadingUsers = true;
    _usersError = null;
    notifyListeners();

    try {
      _allUsers = await _service.getAllUsers();
      _usersError = null;
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  /// Create user
  Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      await _service.createUser(userData);
      await loadUsers();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update user
  Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _service.updateUser(userId, userData);
      await loadUsers();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      await _service.deleteUser(userId);
      await loadUsers();
      return true;
    } catch (e) {
      return false;
    }
  }

  void clearErrors() {
    _statsError = null;
    _ordersError = null;
    _usersError = null;
    _categoriesError = null;
    _itemsError = null;
    notifyListeners();
  }
}

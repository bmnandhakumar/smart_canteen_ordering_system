import "../models/order_model.dart";
import "../models/category_model.dart";
import "../models/item_model.dart";
import "../models/user_model.dart";
import "package:smart_canteen_ordering_system/constants/my_routes.dart";
import "my_client.dart";

class AdminService {
  AdminService._();

  static final AdminService _instance = AdminService._();
  static AdminService get instance => _instance;

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await MyClient.dio.get(
      "/admin/dashboard_stats",
    );
    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      throw Exception(body["message"] ?? "Failed to load dashboard stats");
    }

    return body["data"] as Map<String, dynamic>;
  }

  /// Get all orders for admin view
  Future<List<OrderModel>> getAllOrders() async {
    final response = await MyClient.dio.post(
      MyRoutes.adminGetAllOrders,
    );
    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      return [];
    }

    final list = body["data"] as List;
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    final response = await MyClient.dio.post(
      MyRoutes.adminUpdateOrderStatus,
      data: {
        "order_id": orderId,
        "status": status,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to update order status");
    }
  }

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await MyClient.dio.post(
      MyRoutes.adminGetAllCategories,
    );
    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      return [];
    }

    final list = body["data"] as List;
    return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Create category
  Future<void> createCategory(String name, String description) async {
    final response = await MyClient.dio.post(
      MyRoutes.createCategory,
      data: {
        "name": name,
        "description": description,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to create category");
    }
  }

  /// Update category
  Future<void> updateCategory(String categoryId, String name, String description) async {
    final response = await MyClient.dio.post(
      MyRoutes.updateCategory,
      data: {
        "category_id": categoryId,
        "name": name,
        "description": description,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to update category");
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    final response = await MyClient.dio.post(
      MyRoutes.adminDeleteCategory,
      data: {
        "category_id": categoryId,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to delete category");
    }
  }

  /// Get all items
  Future<List<ItemModel>> getAllItems() async {
    final response = await MyClient.dio.post(
      MyRoutes.adminGetAllItems,
    );
    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      return [];
    }

    final list = body["data"] as List;
    return list.map((e) => ItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Create item
  Future<void> createItem(Map<String, dynamic> itemData) async {
    final response = await MyClient.dio.post(
      MyRoutes.adminCreateItem,
      data: itemData,
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to create item");
    }
  }

  /// Update item
  Future<void> updateItem(String itemId, Map<String, dynamic> itemData) async {
    final response = await MyClient.dio.post(
      MyRoutes.adminUpdateItem,
      data: {
        "item_id": itemId,
        ...itemData,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to update item");
    }
  }

  /// Delete item
  Future<void> deleteItem(String itemId) async {
    final response = await MyClient.dio.post(
      MyRoutes.adminDeleteItem,
      data: {
        "item_id": itemId,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to delete item");
    }
  }

  /// Get all users
  Future<List<UserModel>> getAllUsers() async {
    final response = await MyClient.dio.post(
      MyRoutes.adminGetAllUsers,
    );
    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      return [];
    }

    final list = body["data"] as List;
    return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Create user
  Future<void> createUser(Map<String, dynamic> userData) async {
    final response = await MyClient.dio.post(
      MyRoutes.createUser,
      data: userData,
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to create user");
    }
  }

  /// Update user
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    final response = await MyClient.dio.post(
      MyRoutes.updateUser,
      data: {
        "user_id": userId,
        ...userData,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to update user");
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    final response = await MyClient.dio.post(
      MyRoutes.adminDeleteUser,
      data: {
        "user_id": userId,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"] ?? "Failed to delete user");
    }
  }
}

import "package:dio/dio.dart";
import "package:smart_canteen_ordering_system/constants/my_routes.dart";
import "package:smart_canteen_ordering_system/models/order_model.dart";
import "my_client.dart";

class OrderService {
  OrderService._();

  static final OrderService _instance = OrderService._();
  static OrderService get instance => _instance;

  /// Places a new order
  /// Returns the created order with order_id, status, and estimated_prep_time
  Future<OrderModel> placeOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    final response = await MyClient.dio.post(
      MyRoutes.placeOrder,
      data: {
        "user_id": userId,
        "items": items,
        "total_amount": totalAmount,
      },
    );

    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      throw Exception(body["message"] ?? "Failed to place order");
    }

    // Use fromPlaceOrderResponse for the minimal API response
    return OrderModel.fromPlaceOrderResponse(body["data"] as Map<String, dynamic>);
  }

  /// Get all orders for a user
  Future<List<OrderModel>> getOrders({required String userId}) async {
    final response = await MyClient.dio.post(
      MyRoutes.getOrders,
      data: {"user_id": userId},
    );

    final body = response.data as Map<String, dynamic>;

    if (body["success"] != true || body["data"] == null) {
      return [];
    }

    final list = body["data"] as List;
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get a single order by ID
  Future<OrderModel?> getOrderById({
    required String userId,
    required String orderId,
  }) async {
    try {
      final response = await MyClient.dio.post(
        MyRoutes.getOrderById,
        data: {
          "user_id": userId,
          "order_id": orderId,
        },
      );

      final body = response.data as Map<String, dynamic>;

      if (body["success"] != true || body["data"] == null) {
        return null;
      }

      return OrderModel.fromJson(body["data"] as Map<String, dynamic>);
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }
}

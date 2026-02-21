import "package:dio/dio.dart";
import "package:smart_canteen_ordering_system/constants/my_routes.dart";
import "package:smart_canteen_ordering_system/services/my_client.dart";
import "../models/cart_model.dart";

class CartService {

  Future<CartModel?> getCart() async {
    try {
      final response = await MyClient.dio.get(MyRoutes.getCart);
      final body = response.data as Map<String, dynamic>;

      if (body["success"] == true && body["data"] != null) {
        return CartModel.fromJson(body["data"] as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }


  Future<CartModel?> addItem({ required String itemId, required int quantity }) async {
    try {
      final response = await MyClient.dio.post(
        MyRoutes.addCartItem,
        data: {
          "item_id": itemId,
          "quantity": quantity,
        },
      );
      final body = response.data as Map<String, dynamic>;

      if (body["success"] == true && body["data"] != null) {
        return CartModel.fromJson(body["data"] as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<CartModel?> removeItem({required String itemId}) async {
    try {
      final response = await MyClient.dio.delete(
        MyRoutes.removeCartItem,
        data: {"item_id": itemId},
      );
      final body = response.data as Map<String, dynamic>;

      if (body["success"] == true && body["data"] != null) {
        return CartModel.fromJson(body["data"] as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

}
import "package:dio/dio.dart";
import "package:smart_canteen_ordering_system/constants/my_routes.dart";
import "package:smart_canteen_ordering_system/services/my_client.dart";
import "../models/cart_model.dart";

class CartService {

  Future<CartModel?> getCart() async {
    try {
      final response = await MyClient.dio.post(MyRoutes.getCart,data: {
        "user_id": "bffv6d3dd09v"
      });
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


  Future<CartModel?> addItem({ required String userId, required String itemId, required int quantity }) async {
    try {
      final response = await MyClient.dio.post(
        MyRoutes.addCartItem,
        data: {
          "user_id": userId,
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

  Future<CartModel?> removeItem({required userId, required String itemId}) async {
    try {
      final response = await MyClient.dio.post(
        MyRoutes.removeCartItem,
        data: {"user_id":userId,"item_id": itemId},
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


  Future<CartModel?> deleteAllItems({required String userId}) async {
    try {
      final response = await MyClient.dio.post(
        MyRoutes.deleteAllCartItems,
          data: {"user_id":userId},
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
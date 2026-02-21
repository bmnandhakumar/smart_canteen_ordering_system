import "package:dio/dio.dart";
import "package:smart_canteen_ordering_system/constants/my_routes.dart";
import "package:smart_canteen_ordering_system/services/my_client.dart";
import "../models/item_model.dart";

class ItemService {
  Future<List<ItemModel>> getItemsByCategory(String categoryId) async {
    try {
      Response response = await MyClient.dio.post(
        MyRoutes.getItemsByCategoryId,
        data: {"category_id": categoryId},
      );

      Map<String, dynamic> body = response.data;

      if (body["success"] == true) {
        final data = body["data"] as List<dynamic>;
        return data
            .map((json) => ItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    } catch (_) {
      return [];
    }
  }
}
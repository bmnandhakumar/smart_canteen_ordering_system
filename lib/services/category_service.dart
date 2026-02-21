import '../constants/my_routes.dart';
import '../models/category_model.dart';
import 'my_client.dart';

class CategoryService {

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await MyClient.dio.post(
        MyRoutes.getCategories,
      );

      final List<dynamic> data = response.data["data"] ?? [];

      return data.map((json) => CategoryModel.fromJson(json)).toList();

    } catch (e) {
      return [];
    }
  }
}

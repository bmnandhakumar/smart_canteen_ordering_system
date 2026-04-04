import "package:smart_canteen_ordering_system/constants/my_routes.dart";
import "my_client.dart";

class CrowdService {
  CrowdService._();

  static final CrowdService _instance = CrowdService._();
  static CrowdService get instance => _instance;

  /// Get current crowd level
  Future<Map<String, dynamic>> getCrowdLevel() async {
    final response = await MyClient.dio.get(MyRoutes.getCrowdLevel);

    if (response.data["success"] != true || response.data["data"] == null) {
      throw Exception(response.data["message"] ?? "Failed to fetch crowd data");
    }

    return response.data["data"] as Map<String, dynamic>;
  }

  /// Update crowd level (for admin use)
  Future<bool> updateCrowdLevel(Map<String, dynamic> data) async {
    final response = await MyClient.dio.post(
      MyRoutes.updateCrowdLevel,
      data: data,
    );

    return response.data["success"] == true;
  }
}

import "package:dio/dio.dart";
import "/utils/my_logger.dart";

class CrowdService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.239.192.168:5000",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> getCrowdData() async {
    try {
      final response = await _dio.get("/crowd");
      log(response.data["people"].toString());
      return response.data;
    } catch (e) {
      return {
        "people": 0,
        "level": "LOW",
      };
    }
  }
}


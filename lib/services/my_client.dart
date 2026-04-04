import "package:dio/dio.dart";
import "package:smart_canteen_ordering_system/constants/my_routes.dart";

class MyClient {
  MyClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: MyRoutes.isTesting ? MyRoutes.localUrl : MyRoutes.cloudUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );
}

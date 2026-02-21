import "package:dio/dio.dart";
import "../constants/my_routes.dart";
import "../models/user_model.dart";
import "my_client.dart";

class UserService {

  Future<UserModel> getUserById(String userId) async {
    Response response = await MyClient.dio.post(
      MyRoutes.getUserById,
      data: {
        "user_id": userId,
      },
    );

    return UserModel.fromJson(response.data["data"]);
  }

  Future<UserModel> getUserByEmail(String email) async {

    final response = await MyClient.dio.post(
      MyRoutes.getUserByEmail,
      data: {
        "email": email,
      },
    );

    return UserModel.fromJson(response.data["data"]);
  }


  Future<void> createUser({ required String name, required String email, String role = "student" }) async {
    await MyClient.dio.post(
      MyRoutes.createUser,
      data: {
        "name": name,
        "email": email,
        "role": role,
      },
    );
  }

}

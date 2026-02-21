import "package:flutter/material.dart";
import "../models/user_model.dart";
import "../services/user_service.dart";

class UserProvider extends ChangeNotifier {

  UserService _service = UserService();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _service.getUserById(userId);
    } catch (_) {
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserByEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _service.getUserByEmail(email);
    } catch (_) {
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> createUser({ required String name, required String email, String role = "student" }) async {
    await _service.createUser(
      name: name,
      email: email,
      role: role,
    );
  }
}

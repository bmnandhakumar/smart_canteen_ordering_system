import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 Current User
  User? get currentUser => _auth.currentUser;

  // 🔹 Sign In
  Future<UserCredential> signInWithEmailAndPassword({ required String email, required String password }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // 🔹 Create User
  Future<UserCredential> createUserWithEmailAndPassword({ required String email, required String password }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Send Password Reset
  Future<void> sendPasswordResetEmail({ required String email,}) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

}

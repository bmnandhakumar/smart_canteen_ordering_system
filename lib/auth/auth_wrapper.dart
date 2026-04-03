import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/services/auth_service.dart";
import "package:smart_canteen_ordering_system/widgets/app_loader.dart";
import "package:smart_canteen_ordering_system/widgets/exit_confirmation.dart";
import "../providers/user_provider.dart";
import "../screens/home_screen.dart";
import "login_screen.dart";

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: AppLoader()
          );
        }

        if (snapshot.hasData) {
          final firebaseUser = snapshot.data!;
          return _LoadUserAndNavigate(firebaseUser: firebaseUser);
        }

        return const LoginScreen();
      },
    );
  }
}

class _LoadUserAndNavigate extends StatefulWidget {
  final User firebaseUser;

  const _LoadUserAndNavigate({required this.firebaseUser});

  @override
  State<_LoadUserAndNavigate> createState() =>
      _LoadUserAndNavigateState();
}

class _LoadUserAndNavigateState
    extends State<_LoadUserAndNavigate> {

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = widget.firebaseUser.email;

    if (email != null) {
      await context.read<UserProvider>().fetchUserByEmail(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;

    if (isLoading) {
      return const Scaffold(
        body: AppLoader(),
      );
    }

    return const ExitConfirmationWrapper(child: HomeScreen());
  }
}

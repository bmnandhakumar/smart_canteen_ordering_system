import "package:go_router/go_router.dart";
import "package:smart_canteen_ordering_system/screens/about_screen.dart";
import "package:smart_canteen_ordering_system/screens/help_support_screen.dart";
import "/screens/change_password_screen.dart";
import "../auth/auth_wrapper.dart";
import "../screens/items_screen.dart";

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: "/items/:categoryId",
        builder: (context, state) {
          final categoryId = state.pathParameters["categoryId"]!;
          return ItemsScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: "/change-password",
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
          path: "/help-support",
          builder: (context, state) => const HelpSupportScreen()
      ),
      GoRoute(
          path: "/about",
          builder: (context, state) => const AboutScreen()
      ),
    ],
  );
}

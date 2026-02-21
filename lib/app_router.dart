import "package:go_router/go_router.dart";
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
    ],
  );
}

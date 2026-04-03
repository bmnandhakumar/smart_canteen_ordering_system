import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/screens/about_screen.dart";
import "package:smart_canteen_ordering_system/screens/help_support_screen.dart";
import "/screens/change_password_screen.dart";
import "../auth/auth_wrapper.dart";
import "../screens/items_screen.dart";
import "../screens/order_confirmation_screen.dart";
import "../screens/order_details_screen.dart";
import "../screens/payment_screen.dart";
import "../screens/admin/admin_order_details_screen.dart";
import "../models/order_model.dart";
import "../providers/cart_provider.dart";

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
        path: "/payment",
        builder: (context, state) {
          final cartProvider = context.read<CartProvider>();
          final total = cartProvider.totalPrice + 2; // subtotal + platform fee
          return PaymentScreen(totalAmount: total);
        },
      ),
      GoRoute(
        path: "/order-confirmation",
        builder: (context, state) => const OrderConfirmationScreen(),
      ),
      GoRoute(
        path: "/order-details",
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return OrderDetailsScreen(order: order);
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
      GoRoute(
        path: "/admin/order-details",
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return AdminOrderDetailsScreen(order: order);
        },
      ),
    ],
  );
}

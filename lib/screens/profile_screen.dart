import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/models/order_model.dart" show OrderStatus;
import "package:smart_canteen_ordering_system/widgets/app_loader.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "package:smart_canteen_ordering_system/providers/order_provider.dart";
import "../widgets/profile/profile_header.dart";
import "../widgets/profile/profile_menu_section.dart";
import "../widgets/profile/profile_stats.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user?.userId;

    if (userId != null) {
      await context.read<OrderProvider>().loadOrders(userId);
    }
  }

  int _getOrderCount() {
    final orderProvider = context.read<OrderProvider>();
    // Count all orders except cancelled
    return orderProvider.orders
        .where((o) => o.status != OrderStatus.cancelled)
        .length;
  }

  double _getTotalSpent() {
    final orderProvider = context.read<OrderProvider>();
    // Sum total of all orders except cancelled
    return orderProvider.orders
        .where((o) => o.status != OrderStatus.cancelled)
        .fold<double>(0, (sum, order) => sum + (order.totalAmount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final orderProvider = context.watch<OrderProvider>();

    final orderCount = _getOrderCount();
    final totalSpent = _getTotalSpent();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 16),
              ProfileStats(
                orderCount: orderCount,
                totalSpent: totalSpent,
              ),
              const SizedBox(height: 20),
              const ProfileMenuSection(),
            ],
          ),
        ),
      ),
    );
  }
}

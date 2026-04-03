import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/constants/my_colors.dart";
import "package:smart_canteen_ordering_system/providers/admin_provider.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "package:smart_canteen_ordering_system/screens/admin/admin_orders_screen.dart";
import "package:smart_canteen_ordering_system/screens/admin/admin_menu_screen.dart";
import "package:smart_canteen_ordering_system/screens/admin/admin_users_screen.dart";

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentNavIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _DashboardContent(onTabChanged: _onNavTap),
      const AdminOrdersScreen(),
      const AdminMenuScreen(),
      const AdminUsersScreen(),
    ];
    _loadData();
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  Future<void> _loadData() async {
    final adminProvider = context.read<AdminProvider>();
    await Future.wait([
      adminProvider.loadDashboardStats(),
      adminProvider.loadAllOrders(),
    ]);
  }

  Future<void> _refresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: IndexedStack(
        index: _currentNavIndex,
        children: _screens,
      ),
      bottomNavigationBar: _AdminBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final ValueChanged<int> onTabChanged;

  const _DashboardContent({required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final adminProvider = context.read<AdminProvider>();
            await adminProvider.loadDashboardStats();
          },
          color: MyColors.primaryColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () async {
                        final adminProvider = context.read<AdminProvider>();
                        await adminProvider.loadDashboardStats();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stats Cards Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    _StatCard(
                      label: "Orders Today",
                      value: "${adminProvider.totalOrdersToday}",
                      icon: "🧾",
                      color: const Color(0xFF00A056),
                      isLoading: adminProvider.isLoadingStats,
                    ),
                    _StatCard(
                      label: "Revenue Today",
                      value: "₹${adminProvider.totalRevenueToday.toStringAsFixed(0)}",
                      icon: "💰",
                      color: const Color(0xFFF9A825),
                      isLoading: adminProvider.isLoadingStats,
                    ),
                    _StatCard(
                      label: "Active Orders",
                      value: "${adminProvider.activeOrders}",
                      icon: "⏳",
                      color: const Color(0xFF1976D2),
                      isLoading: adminProvider.isLoadingStats,
                    ),
                    _StatCard(
                      label: "Low Stock",
                      value: "${adminProvider.lowStockItems}",
                      icon: "📦",
                      color: const Color(0xFFE53935),
                      isLoading: adminProvider.isLoadingStats,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick Actions
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _QuickActionCard(
                      title: "Manage Orders",
                      icon: Icons.receipt_long_rounded,
                      color: MyColors.primaryColor,
                      onTap: () => onTabChanged(1),
                    ),
                    _QuickActionCard(
                      title: "Manage Menu",
                      icon: Icons.restaurant_rounded,
                      color: const Color(0xFFF9A825),
                      onTap: () => onTabChanged(2),
                    ),
                    _QuickActionCard(
                      title: "Manage Users",
                      icon: Icons.people_rounded,
                      color: const Color(0xFF1976D2),
                      onTap: () => onTabChanged(3),
                    ),
                    _QuickActionCard(
                      title: "Analytics",
                      icon: Icons.bar_chart_rounded,
                      color: const Color(0xFF9C27B0),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Orders
                const Text(
                  "Recent Orders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                _RecentOrdersList(adminProvider: adminProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final bool isLoading;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isLoading ? "-" : value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentOrdersList extends StatelessWidget {
  final AdminProvider adminProvider;

  const _RecentOrdersList({required this.adminProvider});

  @override
  Widget build(BuildContext context) {
    final orders = adminProvider.allOrders.take(5).toList();

    if (orders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 40,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            const Text(
              "No orders yet",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: orders.map((order) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: MyColors.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.displayId,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      "Token #${order.tokenNumber ?? "N/A"}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "₹${order.totalAmount?.toStringAsFixed(0) ?? "0"}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: MyColors.primaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AdminBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.dashboard_rounded,
                label: "Dashboard",
                index: 0,
                isSelected: currentIndex == 0,
                onTap: onTap,
              ),
              _buildNavItem(
                icon: Icons.receipt_long_rounded,
                label: "Orders",
                index: 1,
                isSelected: currentIndex == 1,
                onTap: onTap,
              ),
              _buildNavItem(
                icon: Icons.restaurant_rounded,
                label: "Menu",
                index: 2,
                isSelected: currentIndex == 2,
                onTap: onTap,
              ),
              _buildNavItem(
                icon: Icons.people_rounded,
                label: "Users",
                index: 3,
                isSelected: currentIndex == 3,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required ValueChanged<int> onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? MyColors.primaryColor : const Color(0xFF888888),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? MyColors.primaryColor : const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/constants/my_colors.dart";
import "package:smart_canteen_ordering_system/models/order_model.dart";
import "package:smart_canteen_ordering_system/providers/admin_provider.dart";
import "package:go_router/go_router.dart";

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  int _selectedTab = 1; // Default to "Not Received" (active orders)
  final List<String> _tabs = ["All", "Not Received", "Received"];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    await context.read<AdminProvider>().loadAllOrders();
  }

  Future<void> _refresh() async {
    await _loadOrders();
  }

  List<OrderModel> _getFilteredOrders(AdminProvider adminProvider) {
    final orders = adminProvider.allOrders;
    switch (_selectedTab) {
      case 0: // All
        return orders;
      case 1: // Not Received
        return orders
            .where((o) => o.status == OrderStatus.notReceived)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 2: // Received
        return orders
            .where((o) => o.status == OrderStatus.received)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      default:
        return [];
    }
  }

  String _getStatusDisplay(OrderStatus status) {
    switch (status) {
      case OrderStatus.notReceived:
        return "Not Received";
      case OrderStatus.received:
        return "Received";
      case OrderStatus.confirmed:
        return "Confirmed";
      case OrderStatus.preparing:
        return "Preparing";
      case OrderStatus.ready:
        return "Ready";
      case OrderStatus.completed:
        return "Completed";
      case OrderStatus.cancelled:
        return "Cancelled";
      default:
        return "Pending";
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.notReceived:
        return const Color(0xFFF9A825);
      case OrderStatus.received:
        return const Color(0xFF1976D2);
      case OrderStatus.confirmed:
        return const Color(0xFF00A056);
      case OrderStatus.preparing:
        return const Color(0xFFF9A825);
      case OrderStatus.ready:
        return const Color(0xFF2E7D32);
      case OrderStatus.completed:
        return const Color(0xFF888888);
      case OrderStatus.cancelled:
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF888888);
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }

  List<OrderModel> _getFilteredSearchResults(AdminProvider adminProvider) {
    if (_searchController.text.isEmpty) {
      return _getFilteredOrders(adminProvider);
    }

    final query = _searchController.text.toLowerCase();
    return _getFilteredOrders(adminProvider).where((order) {
      return order.displayId.toLowerCase().contains(query) ||
          (order.tokenNumber?.toString() ?? "").contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              color: const Color(0xFFF4F6F4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: _refresh,
                  ),
                ],
              ),
            ),

            // Tab chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 8 : 0),
                    child: _TabChip(
                      label: _tabs[index],
                      isSelected: _selectedTab == index,
                      onTap: () => setState(() => _selectedTab = index),
                    ),
                  );
                }),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Search by order ID or token...",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF888888)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFF888888)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Order list
            Expanded(
              child: _buildOrderList(adminProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(AdminProvider adminProvider) {
    if (adminProvider.isLoadingOrders) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A056),
        ),
      );
    }

    if (adminProvider.ordersError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade300,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              adminProvider.ordersError!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                elevation: 0,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final filteredOrders = _getFilteredSearchResults(adminProvider);

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No ${_tabs[_selectedTab].toLowerCase()} orders",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _selectedTab == 0 ? "Orders will appear here" : "Try a different tab",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: MyColors.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AdminOrderCard(
              order: order,
              statusDisplay: _getStatusDisplay(order.status),
              statusColor: _getStatusColor(order.status),
              timeAgo: _getTimeAgo(order.createdAt),
              onTap: () => context.push("/admin/order-details", extra: order),
            ),
          );
        },
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? MyColors.primaryColor
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  final String statusDisplay;
  final Color statusColor;
  final String timeAgo;
  final VoidCallback onTap;

  const _AdminOrderCard({
    required this.order,
    required this.statusDisplay,
    required this.statusColor,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: MyColors.primaryColor,
                    size: 20,
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
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (order.tokenNumber != null)
                        Text(
                          "Token #${order.tokenNumber}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        _getItemsSummary(order),
                        style: const TextStyle(
                          fontSize: 12,
                            color: Color(0xFF888888),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${order.totalAmount?.toStringAsFixed(0) ?? "0"}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFFAAAAAA)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: const Color(0xFFF0F0F0),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    statusDisplay,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                ),
                Text(
                  "View Details →",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getItemsSummary(OrderModel order) {
    if (order.isMinimal || order.items == null || order.items!.isEmpty) {
      return "No items";
    }

    final itemNames = order.items!.map((item) => item.name).where((name) => name != null && name.isNotEmpty).take(3).toList();

    if (itemNames.isEmpty) {
      return "${order.items!.length} item${order.items!.length > 1 ? "s" : ""}";
    }

    final summary = itemNames.join(", ");
    if (order.items!.length > 3) {
      return "$summary +${order.items!.length - 3} more";
    }

    return summary;
  }
}

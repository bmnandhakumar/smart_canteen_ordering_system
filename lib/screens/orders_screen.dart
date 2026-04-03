import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/constants/my_colors.dart";
import "package:smart_canteen_ordering_system/models/order_model.dart";
import "package:smart_canteen_ordering_system/providers/order_provider.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "package:go_router/go_router.dart";

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ["Active", "Completed", "Cancelled"];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user!.userId!;
    await context.read<OrderProvider>().loadOrders(userId);
  }

  Future<void> _refresh() async {
    final userProvider = context.read<UserProvider>();
    final userId = userProvider.user!.userId!;
    await context.read<OrderProvider>().refreshOrders(userId);
  }

  List<OrderModel> _getFilteredOrders(OrderProvider orderProvider) {
    switch (_selectedTab) {
      case 0: // Active
        return orderProvider.activeOrders;
      case 1: // Completed
        return orderProvider.completedOrders;
      case 2: // Cancelled
        return orderProvider.cancelledOrders;
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
        return const Color(0xFFF9A825); // Amber
      case OrderStatus.received:
        return const Color(0xFF1976D2); // Blue
      case OrderStatus.confirmed:
        return const Color(0xFF00A056); // Green
      case OrderStatus.preparing:
        return const Color(0xFFF9A825); // Amber
      case OrderStatus.ready:
        return const Color(0xFF2E7D32); // Dark Green
      case OrderStatus.completed:
        return const Color(0xFF888888); // Grey
      case OrderStatus.cancelled:
        return const Color(0xFFE53935); // Red
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
      return "${difference.inMinutes} min${difference.inMinutes > 1 ? "s" : ""} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? "s" : ""} ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              color: const Color(0xFFF4F6F4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  if (!orderProvider.isLoading && orderProvider.orders.isNotEmpty)
                    TextButton(
                      onPressed: _refresh,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Refresh",
                            style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

            // Order list
            Expanded(
              child: _buildOrderList(orderProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(OrderProvider orderProvider) {
    if (orderProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A056),
        ),
      );
    }

    if (orderProvider.hasError) {
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
              orderProvider.errorMessage ?? "Failed to load orders",
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

    final filteredOrders = _getFilteredOrders(orderProvider);

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 38,
                color: MyColors.primaryColor.withOpacity(0.40),
              ),
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
              _selectedTab == 0
                  ? "Place an order to see it here"
                  : "Completed orders will appear here",
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
            child: _OrderCard(
              order: order,
              items: _getItemsSummary(order),
              status: _getStatusDisplay(order.status),
              statusColor: _getStatusColor(order.status),
              time: _getTimeAgo(order.createdAt),
            ),
          );
        },
      ),
    );
  }

  String _getItemsSummary(OrderModel order) {
    if (order.items == null || order.items!.isEmpty) {
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

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final String items;
  final String status;
  final Color statusColor;
  final String time;

  const _OrderCard({
    required this.order,
    required this.items,
    required this.status,
    required this.statusColor,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final total = "₹${order.totalAmount?.toStringAsFixed(0) ?? "0"}";

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
                    Text(
                      items,
                      style: const TextStyle(
                        fontSize: 12.5,
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
                    total,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
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
              if (order.tokenNumber != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Token #${order.tokenNumber}",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
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
                  status,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push("/order-details", extra: order),
                child: Text(
                  "View Details →",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

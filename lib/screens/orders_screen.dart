import "package:flutter/material.dart";
import "../constants/my_colors.dart";

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              color: const Color(0xFFF4F6F4),
              child: const Text(
                "My Orders",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.4,
                ),
              ),
            ),

            // ── Tab chips ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _TabChip(label: "Active", isSelected: true),
                  const SizedBox(width: 8),
                  _TabChip(label: "Completed", isSelected: false),
                  const SizedBox(width: 8),
                  _TabChip(label: "Cancelled", isSelected: false),
                ],
              ),
            ),

            // ── Order list ────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: const [
                  _OrderCard(
                    orderId: "#ORD-2401",
                    items: "Masala Dosa, Filter Coffee",
                    total: "₹85",
                    status: "Preparing",
                    statusColor: Color(0xFFF9A825),
                    time: "2 mins ago",
                  ),
                  SizedBox(height: 12),
                  _OrderCard(
                    orderId: "#ORD-2398",
                    items: "Veg Meals, Lassi",
                    total: "₹120",
                    status: "Ready",
                    statusColor: Color(0xFF2E7D32),
                    time: "12 mins ago",
                  ),
                  SizedBox(height: 12),
                  _OrderCard(
                    orderId: "#ORD-2390",
                    items: "Samosa x2, Chai",
                    total: "₹45",
                    status: "Completed",
                    statusColor: Color(0xFF888888),
                    time: "Yesterday",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TabChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String items;
  final String total;
  final String status;
  final Color statusColor;
  final String time;

  const _OrderCard({
    required this.orderId,
    required this.items,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.time,
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
                      orderId,
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
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              const Spacer(),
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
    );
  }
}
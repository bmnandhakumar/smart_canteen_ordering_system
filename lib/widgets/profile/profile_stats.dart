import "package:flutter/material.dart";

class ProfileStats extends StatelessWidget {
  final int orderCount;
  final double totalSpent;

  const ProfileStats({
    super.key,
    required this.orderCount,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _StatItem(
              label: "Orders",
              value: orderCount.toString(),
              icon: "🧾",
            ),
            _Divider(),
            _StatItem(
              label: "Spent",
              value: "₹${_formatAmount(totalSpent)}",
              icon: "💳",
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(1)}k";
    }
    return amount.toStringAsFixed(0);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: const Color(0xFFEEEEEE));
}

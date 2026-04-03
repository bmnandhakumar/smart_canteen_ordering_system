import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../constants/my_colors.dart";
import "../../providers/cart_provider.dart";
import "../primary_button.dart";

class BillSummary extends StatelessWidget {
  final CartProvider cartProvider;
  static const double _platformFee = 2;

  const BillSummary({required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    final subtotal = cartProvider.totalPrice;
    final total = subtotal + _platformFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _BillRow(
            label: "Subtotal",
            value: "₹${subtotal.toStringAsFixed(0)}",
          ),
          const SizedBox(height: 6),
          const _BillRow(label: "Platform fee", value: "₹2"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFFF0F0F0)),
          ),
          _BillRow(
            label: "Total",
            value: "₹${total.toStringAsFixed(0)}",
            isBold: true,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: "Place Order · ₹${total.toStringAsFixed(0)}",
            onPressed: () {
              context.push("/payment");
            },
            trailingIcon: Icons.check_circle_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BillRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13.5,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? const Color(0xFF1A1A1A) : const Color(0xFF666666),
        ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 13.5,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color:
            isBold ? MyColors.primaryColor : const Color(0xFF1A1A1A),
        ),
      ),
      ],
    );
  }
}

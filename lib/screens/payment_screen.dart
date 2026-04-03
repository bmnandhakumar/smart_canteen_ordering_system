import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/constants/my_colors.dart";
import "package:smart_canteen_ordering_system/providers/cart_provider.dart";
import "package:smart_canteen_ordering_system/widgets/primary_button.dart";
import "package:go_router/go_router.dart";

enum PaymentMethod {
  cod,
  wallet,
  upi,
  card,
}

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.cod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Payment",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bill Summary Card
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        final subtotal = cartProvider.totalPrice;
                        const platformFee = 2.0;
                        final total = subtotal + platformFee;
                        return _BillSummaryCard(
                          subtotal: subtotal,
                          platformFee: platformFee,
                          total: total,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Payment Methods
                    const Text(
                      "Select Payment Method",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Options
                    _PaymentOption(
                      value: PaymentMethod.cod,
                      groupValue: _selectedMethod,
                      onChanged: (value) => setState(() => _selectedMethod = value!),
                      icon: "💵",
                      title: "Cash on Delivery",
                      subtitle: "Pay with cash when your order arrives",
                    ),
                    const SizedBox(height: 12),
                    _PaymentOption(
                      value: PaymentMethod.wallet,
                      groupValue: _selectedMethod,
                      onChanged: (value) => setState(() => _selectedMethod = value!),
                      icon: "👛",
                      title: "Canteen Wallet",
                      subtitle: "Use your wallet balance",
                      badge: "Coming Soon",
                    ),
                    const SizedBox(height: 12),
                    _PaymentOption(
                      value: PaymentMethod.upi,
                      groupValue: _selectedMethod,
                      onChanged: (value) => setState(() => _selectedMethod = value!),
                      icon: "📱",
                      title: "UPI",
                      subtitle: "Pay with UPI apps (GPay, PhonePe, etc.)",
                      badge: "Coming Soon",
                    ),
                    const SizedBox(height: 12),
                    _PaymentOption(
                      value: PaymentMethod.card,
                      groupValue: _selectedMethod,
                      onChanged: (value) => setState(() => _selectedMethod = value!),
                      icon: "💳",
                      title: "Credit / Debit Card",
                      subtitle: "Pay with your card",
                      badge: "Coming Soon",
                    ),
                    const SizedBox(height: 24),

                    // Security Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MyColors.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: MyColors.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Secure payment powered by Smart Canteen",
                              style: TextStyle(
                                fontSize: 13,
                                color: MyColors.primaryColor.withOpacity(0.80),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Pay Button
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final subtotal = cartProvider.totalPrice;
                const platformFee = 2.0;
                final total = subtotal + platformFee;

                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Total Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            "₹${total.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Pay Button
                      PrimaryButton(
                        label: "Pay ₹${total.toStringAsFixed(0)}",
                        onPressed: () => _handlePayment(context),
                        trailingIcon: Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context) async {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ProcessingDialog(method: _selectedMethod),
    );

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close processing dialog

      // Navigate to order confirmation screen with payment method
      context.push("/order-confirmation", extra: {
        "payment_method": _getPaymentMethodName(_selectedMethod),
      });
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cod:
        return "Cash on Delivery";
      case PaymentMethod.wallet:
        return "Canteen Wallet";
      case PaymentMethod.upi:
        return "UPI";
      case PaymentMethod.card:
        return "Card";
    }
  }
}

class _BillSummaryCard extends StatelessWidget {
  final double subtotal;
  final double platformFee;
  final double total;

  const _BillSummaryCard({
    required this.subtotal,
    required this.platformFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bill Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
          ),
          ),
          const SizedBox(height: 16),
          _BillRow(label: "Subtotal", value: "₹${subtotal.toStringAsFixed(0)}"),
          const SizedBox(height: 10),
          const _BillRow(label: "Platform fee", value: "₹2"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF0F0F0)),
          ),
          _BillRow(
            label: "Total",
            value: "₹${total.toStringAsFixed(0)}",
            isBold: true,
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
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? const Color(0xFF1A1A1A) : const Color(0xFF666666),
        ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? MyColors.primaryColor : const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final PaymentMethod value;
  final PaymentMethod groupValue;
  final ValueChanged<PaymentMethod?> onChanged;
  final String icon;
  final String title;
  final String subtitle;
  final String? badge;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final isDisabled = badge != null && badge == "Coming Soon";

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? MyColors.primaryColor.withOpacity(0.06) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? MyColors.primaryColor : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDisabled
                                ? const Color(0xFF888888)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badge == "Coming Soon"
                                  ? const Color(0xFFFFF3CD)
                                  : MyColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: badge == "Coming Soon"
                                    ? const Color(0xFF856404)
                                    : MyColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDisabled
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),

              // Radio
              if (!isDisabled)
                Transform.scale(
                  scale: 1.1,
                  child: Radio<PaymentMethod>(
                    value: value,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: MyColors.primaryColor,
                  ),
                )
              else
                Icon(
                  Icons.lock_rounded,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessingDialog extends StatelessWidget {
  final PaymentMethod method;

  const _ProcessingDialog({required this.method});

  String _getMethodText() {
    switch (method) {
      case PaymentMethod.cod:
        return "Confirming order...";
      case PaymentMethod.wallet:
        return "Processing wallet payment...";
      case PaymentMethod.upi:
        return "Initiating UPI payment...";
      case PaymentMethod.card:
        return "Processing card payment...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF00A056),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              _getMethodText(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please wait",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/constants/my_colors.dart";
import "package:smart_canteen_ordering_system/models/item_model.dart";
import "package:smart_canteen_ordering_system/providers/cart_provider.dart";
import "package:smart_canteen_ordering_system/providers/order_provider.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "package:smart_canteen_ordering_system/services/cart_service.dart";
import "package:smart_canteen_ordering_system/widgets/primary_button.dart";
import "package:go_router/go_router.dart";

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  bool _isLoading = true;
  List<ItemModel> _items = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItemDetails();
  }

  Future<void> _loadItemDetails() async {
    final cartProvider = context.read<CartProvider>();

    if (cartProvider.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final cartService = CartService();
      final itemIds = cartProvider.cart!.items.map((e) => e.itemId).toList();
      final items = await cartService.getItemsByIds(itemIds);

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load item details";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();

    if (_isLoading) {
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
            "Confirm Order",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00A056),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
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
            "Confirm Order",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFE53935),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                ),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

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
          "Confirm Order",
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
                    // Estimated time card
                    _EstimateCard(),
                    const SizedBox(height: 16),

                    // Order items header
                    const Text(
                      "Order Items",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Items list
                    ..._buildItemsList(cartProvider),

                    const SizedBox(height: 16),

                    // Bill summary
                    _BillSummary(cartProvider: cartProvider),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom confirm button
            Container(
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
                  // Error message
                  if (orderProvider.placeOrderError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Color(0xFFE53935),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              orderProvider.placeOrderError!,
                              style: const TextStyle(
                                color: Color(0xFFB71C1C),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Confirm button
                  PrimaryButton(
                    label: "Confirm Order",
                    isLoading: orderProvider.isPlacingOrder,
                    onPressed: () => _handlePlaceOrder(context, cartProvider),
                    trailingIcon: Icons.check_circle_outline_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemsList(CartProvider cartProvider) {
    if (cartProvider.isEmpty) return [];

    final items = cartProvider.cart!.items;
    final itemCache = <String, ItemModel>{};
    for (final item in _items) {
      if (item.itemId != null) {
        itemCache[item.itemId!] = item;
      }
    }

    return items.map((cartItem) {
      final itemModel = itemCache[cartItem.itemId];
      if (itemModel == null) return const SizedBox.shrink();

      final name = itemModel.name ?? "Item";
      final price = itemModel.price ?? 0.0;
      final imageUrl = itemModel.imageUrl;
      final lineTotal = price * cartItem.quantity;

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 56,
                height: 56,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                      )
                    : const _ImagePlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: Color(0xFF1A1A1A),
                  ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "₹${price.toStringAsFixed(0)} × ${cartItem.quantity}",
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "₹${lineTotal.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: MyColors.primaryColor,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _handlePlaceOrder(BuildContext context, CartProvider cartProvider) async {
    final userProvider = context.read<UserProvider>();
    final orderProvider = context.read<OrderProvider>();

    final userId = userProvider.user!.userId!;

    // Build items list with proper null handling
    final items = <Map<String, dynamic>>[];
    for (final cartItem in cartProvider.cart!.items) {
      final itemModel = _items.firstWhere(
        (i) => i.itemId == cartItem.itemId,
        orElse: () => ItemModel(),
      );
      items.add({
        "item_id": cartItem.itemId,
        "quantity": cartItem.quantity,
        "price": itemModel.price ?? 0.0,
      });
    }

    final totalAmount = cartProvider.totalPrice;

    final order = await orderProvider.placeOrder(
      userId: userId,
      items: items,
      totalAmount: totalAmount,
    );

    if (order != null && context.mounted) {
      // Clear cart
      await cartProvider.deleteAllItems(userId);

      // Show success dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _OrderSuccessDialog(orderId: order.orderId),
        ).then((_) {
          // Pop confirmation screen
          context.pop();
          // Refresh orders to get full details
          if (context.mounted) {
            context.read<OrderProvider>().refreshOrders(userId);
          }
        });
      }
    }
  }
}

class _EstimateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryColor.withOpacity(0.12),
            MyColors.primaryColor.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: MyColors.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Estimated Preparation",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "10-15 minutes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: MyColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BillSummary extends StatelessWidget {
  final CartProvider cartProvider;

  const _BillSummary({required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    final subtotal = cartProvider.totalPrice;
    const platformFee = 2.0;
    final total = subtotal + platformFee;

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          _BillRow(label: "Subtotal", value: "₹${subtotal.toStringAsFixed(0)}"),
          const SizedBox(height: 8),
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
            color: isBold ? MyColors.primaryColor : const Color(0xFF1A1A1A),
        ),
      ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.primaryColor.withOpacity(0.08),
      child: Icon(
        Icons.fastfood_rounded,
        color: MyColors.primaryColor.withOpacity(0.35),
        size: 28,
      ),
    );
  }
}

class _OrderSuccessDialog extends StatelessWidget {
  final String orderId;

  const _OrderSuccessDialog({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: MyColors.primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),

            // Success text
            const Text(
              "Order Placed!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Order #${orderId.substring(0, orderId.length > 6 ? 6 : orderId.length).toUpperCase()}",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              "Your order is being prepared",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),

            // Done button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

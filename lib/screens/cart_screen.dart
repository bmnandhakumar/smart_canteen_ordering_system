import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../constants/my_colors.dart";
import "../models/cart_model.dart";
import "../models/item_model.dart";
import "../providers/cart_provider.dart";
import "../widgets/primary_button.dart";

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, cartProvider),
            Expanded(child: _buildBody(context, cartProvider)),
            if (!cartProvider.isLoading && !cartProvider.isEmpty)
              _BillSummary(cartProvider: cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
      color: const Color(0xFFF4F6F4),
      child: Row(
        children: [
          const Text(
            "My Cart",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.4,
            ),
          ),
          const Spacer(),

          // Item count badge
          if (!cartProvider.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? "item" : "items"}",
                style: TextStyle(
                  fontSize: 13,
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          // Clear all button
          if (!cartProvider.isEmpty) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _confirmClear(context, cartProvider),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE53935),
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartProvider cartProvider) {
    if (cartProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
        ),
      );
    }

    if (cartProvider.isEmpty) {
      return const _EmptyCartState();
    }

    final items = cartProvider.cart!.items;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final cartItem = items[i];
        // Join with ItemModel from provider cache for name/price/image
        final itemModel = cartProvider.itemCache[cartItem.itemId];

        return _CartItemCard(
          cartItem: cartItem,
          itemModel: itemModel,
          onIncrement: () =>
              context.read<CartProvider>().addItem(cartItem.itemId),
          onDecrement: () =>
              context.read<CartProvider>().decrementItem(cartItem.itemId),
          onRemove: () =>
              context.read<CartProvider>().removeItem(cartItem.itemId),
        );
      },
    );
  }



  void _confirmClear(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          "Clear Cart?",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        content: const Text(
          "All items will be removed from your cart.",
          style: TextStyle(color: Color(0xFF666666), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(
                  color: MyColors.primaryColor, fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text(
              "Clear",
              style: TextStyle(
                  color: Color(0xFFE53935), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}


class _CartItemCard extends StatelessWidget {
  final CartItemModel cartItem;
  final ItemModel? itemModel; // null if not yet in provider cache
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.cartItem,
    required this.itemModel,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final name = itemModel?.name ?? "Item";
    final price = itemModel?.price ?? 0.0;
    final imageUrl = itemModel?.imageUrl;
    final lineTotal = price * cartItem.quantity;

    return Dismissible(
      key: Key(cartItem.itemId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Color(0xFFE53935),
          size: 24,
        ),
      ),
      child: Container(
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
            // ── Image ─────────────────────────────────────────────
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
                    "₹${price.toStringAsFixed(0)} each",
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${lineTotal.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // ── Vertical qty stepper ──────────────────────────────
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QtyBtn(icon: Icons.add, onTap: onIncrement, isAdd: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    "${cartItem.quantity}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                _QtyBtn(icon: Icons.remove, onTap: onDecrement),
              ],
            ),
          ],
        ),
      ),
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

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isAdd;

  const _QtyBtn({
    required this.icon,
    required this.onTap,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isAdd
              ? MyColors.primaryColor
              : MyColors.primaryColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isAdd ? Colors.white : MyColors.primaryColor,
        ),
      ),
    );
  }
}


class _BillSummary extends StatelessWidget {
  final CartProvider cartProvider;
  static const double _platformFee = 2;

  const _BillSummary({required this.cartProvider});

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
              // TODO: Navigate to checkout / order confirmation screen
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

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 44,
              color: MyColors.primaryColor.withOpacity(0.50),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Browse categories and add items\nto get started",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF888888),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
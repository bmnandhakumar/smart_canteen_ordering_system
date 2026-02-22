import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "../constants/my_colors.dart";
import "../providers/cart_provider.dart";
import "../widgets/cart/bill_summary.dart";
import "../widgets/cart/cart_item_card.dart";

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
              BillSummary(cartProvider: cartProvider),
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

        return CartItemCard(
          cartItem: cartItem,
          itemModel: itemModel,
          onIncrement: () =>
              context.read<CartProvider>().addItem(context.read<UserProvider>().user!.userId!,cartItem.itemId),
          onDecrement: () =>
              context.read<CartProvider>().decrementItem(context.read<UserProvider>().user!.userId!,cartItem.itemId),
          onRemove: () =>
              context.read<CartProvider>().removeItem(context.read<UserProvider>().user!.userId!,cartItem.itemId),
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
              cartProvider.deleteAllItems(context.read<UserProvider>().user!.userId!);
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
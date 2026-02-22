import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../constants/my_colors.dart";
import "../providers/cart_provider.dart";

class FloatingCartButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingCartButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final itemCount = cartProvider.totalQuantity;
    final totalPrice = cartProvider.totalPrice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryColor.withOpacity(0.45),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: MyColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        itemCount > 9 ? "9+" : "$itemCount",
                        style: TextStyle(
                          color: MyColors.primaryColor,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$itemCount ${itemCount == 1 ? "item" : "items"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
                Text(
                  "₹${totalPrice.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
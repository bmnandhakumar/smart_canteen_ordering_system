import "package:flutter/material.dart";

import "../../constants/my_colors.dart";
import "../../models/cart_model.dart";
import "../../models/item_model.dart";

class CartItemCard extends StatelessWidget {
  final CartItemModel cartItem;
  final ItemModel? itemModel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
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

    return Container(
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

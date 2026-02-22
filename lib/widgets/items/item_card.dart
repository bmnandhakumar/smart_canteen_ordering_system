import "package:flutter/material.dart";

import "../../constants/my_colors.dart";
import "../../models/item_model.dart";

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final int qty;
  final bool isLoading;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ItemCard({
    required this.item,
    required this.qty,
    required this.isLoading,
    required this.onIncrement,
    required this.onDecrement,
  });

  bool get _isAvailable => item.isAvailable ?? true;
  bool get _inStock => (item.stockQuantity ?? 1) > 0;
  bool get _canAdd => _isAvailable && _inStock;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _canAdd ? 1.0 : 0.55,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 130,
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const _FallbackImage(),
                    )
                        : const _FallbackImage(),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: const Color(0xFF2E7D32),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!_canAdd)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        !_isAvailable ? "Unavailable" : "Out of Stock",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "—",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF888888),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "₹${item.price?.toStringAsFixed(0) ?? "0"}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: MyColors.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        if (isLoading)
                          SizedBox(
                            width: 60,
                            height: 26,
                            child: Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      MyColors.primaryColor),
                                ),
                              ),
                            ),
                          )
                        else if (qty == 0)
                          _AddButton(
                            enabled: _canAdd,
                            onTap: _canAdd ? onIncrement : null,
                          )
                        else
                          _QtyStepper(
                            qty: qty,
                            onIncrement: onIncrement,
                            onDecrement: onDecrement,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _AddButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onTap;

  const _AddButton({required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: enabled ? MyColors.primaryColor : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "ADD",
          style: TextStyle(
            color: enabled ? Colors.white : const Color(0xFFAAAAAA),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}


class _QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QtyStepper({
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              "$qty",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _StepBtn(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}


class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.primaryColor.withOpacity(0.08),
      child: Icon(
        Icons.fastfood_rounded,
        size: 40,
        color: MyColors.primaryColor.withOpacity(0.35),
      ),
    );
  }
}
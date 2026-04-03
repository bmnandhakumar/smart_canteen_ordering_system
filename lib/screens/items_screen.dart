import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "../constants/my_colors.dart";
import "../models/item_model.dart";
import "../providers/cart_provider.dart";
import "../services/item_service.dart";
import "../widgets/items/item_card.dart";

class ItemsScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const ItemsScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ItemService _itemService = ItemService();

  List<ItemModel> _items = [];
  bool _isLoading = true;
  bool _hasError = false;

  final Set<String> _loadingItems = {};

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _itemService.getItemsByCategory(
        widget.categoryId ?? "",
      );

      if (!mounted) return;
      setState(() {
        _items = result;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleIncrement(String itemId) async {
    setState(() => _loadingItems.add(itemId));
    await context.read<CartProvider>().addItem(context.read<UserProvider>().user!.userId!,itemId);
    if (mounted) setState(() => _loadingItems.remove(itemId));
  }

  Future<void> _handleDecrement(String itemId) async {
    setState(() => _loadingItems.add(itemId));
    await context.read<CartProvider>().decrementItem(context.read<UserProvider>().user!.userId!,itemId);
    if (mounted) setState(() => _loadingItems.remove(itemId));
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              if (_isLoading)
                const SliverFillRemaining(child: _LoadingState())
              else if (_hasError)
                SliverFillRemaining(child: _ErrorState(onRetry: _loadItems))
              else if (_items.isEmpty)
                  const SliverFillRemaining(child: _EmptyState())
                else
                  _buildItemGrid(cartProvider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: MyColors.primaryColor,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        title: Text(
          widget.categoryName ?? "Menu",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryColor,
                MyColors.primaryColor.withValues(alpha: 0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 40,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemGrid(CartProvider cartProvider) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        cartProvider.totalQuantity > 0 ? 100 : 24,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = _items[index];
            final itemId = item.itemId ?? "";
            return ItemCard(
              item: item,
              qty: cartProvider.quantityOf(itemId),
              isLoading: _loadingItems.contains(itemId),
              onIncrement: () => _handleIncrement(itemId),
              onDecrement: () => _handleDecrement(itemId),
            );
          },
          childCount: _items.length,
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor:
              AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Loading items...",
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 52, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 14),
          const Text(
            "Couldn't load items",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3A3A3A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Check your connection and try again",
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
              decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Retry",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_menu_rounded,
              size: 56, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 14),
          const Text(
            "No items available",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3A3A3A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "This category has no items right now",
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}
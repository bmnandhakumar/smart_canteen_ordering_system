import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/constants/my_colors.dart";
import "package:smart_canteen_ordering_system/models/category_model.dart";
import "package:smart_canteen_ordering_system/models/item_model.dart";
import "package:smart_canteen_ordering_system/providers/admin_provider.dart";
import "package:smart_canteen_ordering_system/screens/admin/category_form_screen.dart";
import "package:smart_canteen_ordering_system/screens/admin/item_form_screen.dart";

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final adminProvider = context.read<AdminProvider>();
    await Future.wait([
      adminProvider.loadCategories(),
      adminProvider.loadItems(),
    ]);
  }

  Future<void> _refresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              color: const Color(0xFFF4F6F4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Menu Management",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: _refresh,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF888888),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "Categories"),
                  Tab(text: "Items"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _CategoriesTab(
                    onEdit: (category) => _showCategoryForm(category: category),
                    onDeactivate: (category) => _confirmDeactivateCategory(category),
                    onReactivate: (category) => _confirmReactivateCategory(category),
                  ),
                  _ItemsTab(
                    onEdit: (item) => _showItemForm(item: item),
                    onDeactivate: (item) => _confirmDeactivateItem(item),
                    onReactivate: (item) => _confirmReactivateItem(item),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _showCategoryForm();
          } else {
            _showItemForm();
          }
        },
        backgroundColor: MyColors.primaryColor,
        icon: const Icon(Icons.add_rounded),
        label: Text(_tabController.index == 0 ? "Add Category" : "Add Item"),
      ),
    );
  }

  Future<void> _showCategoryForm({CategoryModel? category}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFormScreen(category: category),
    );
    if (mounted) {
      context.read<AdminProvider>().loadCategories();
    }
  }

  Future<void> _showItemForm({ItemModel? item}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemFormScreen(item: item),
    );
    if (mounted) {
      context.read<AdminProvider>().loadItems();
    }
  }

  Future<void> _confirmDeactivateCategory(CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Deactivate Category",
          style: TextStyle(
            color: MyColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("Are you sure you want to deactivate \"${category.name}\"?\n\nIt will be hidden from users but won't be permanently deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9A825),
              foregroundColor: Colors.white,
            ),
            child: const Text("Deactivate"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final adminProvider = context.read<AdminProvider>();
      final success = await adminProvider.deleteCategory(category.categoryId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  success ? "Category deactivated" : "Failed to deactivate",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: success ? MyColors.primaryColor : const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _confirmDeactivateItem(ItemModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Deactivate Item",
          style: TextStyle(
            color: MyColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("Are you sure you want to deactivate \"${item.name}\"?\n\nIt will be hidden from users but won't be permanently deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9A825),
              foregroundColor: Colors.white,
            ),
            child: const Text("Deactivate"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final adminProvider = context.read<AdminProvider>();
      final success = await adminProvider.deleteItem(item.itemId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  success ? "Item deactivated" : "Failed to deactivate",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: success ? MyColors.primaryColor : const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _confirmReactivateCategory(CategoryModel category) async {
    if ((category.isActive ?? false)) return; // Already active

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Reactivate Category",
          style: TextStyle(
            color: MyColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("Reactivate \"${category.name}\"? It will be visible to users again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Reactivate"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final adminProvider = context.read<AdminProvider>();
      final success = await adminProvider.updateCategory(
        category.categoryId!,
        category.name ?? "",
        category.description ?? "",
        isActive: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  success ? "Category reactivated" : "Failed to reactivate",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: success ? MyColors.primaryColor : const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _confirmReactivateItem(ItemModel item) async {
    if ((item.isAvailable ?? false)) return; // Already available

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Reactivate Item",
          style: TextStyle(
            color: MyColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("Reactivate \"${item.name}\"? It will be visible to users again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Reactivate"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final adminProvider = context.read<AdminProvider>();
      final success = await adminProvider.updateItem(
        item.itemId!,
        {
          "name": item.name ?? "",
          "category_id": item.categoryId ?? "",
          "description": item.description ?? "",
          "price": item.price ?? 0,
          "image_url": item.imageUrl ?? "",
          "stock_quantity": item.stockQuantity ?? 0,
          "is_available": true,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  success ? "Item reactivated" : "Failed to reactivate",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: success ? MyColors.primaryColor : const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}

class _CategoriesTab extends StatefulWidget {
  final Function(CategoryModel) onEdit;
  final Function(CategoryModel) onDeactivate;
  final Function(CategoryModel) onReactivate;

  const _CategoriesTab({
    required this.onEdit,
    required this.onDeactivate,
    required this.onReactivate,
  });

  @override
  State<_CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<_CategoriesTab> {
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Active", "Inactive"];

  List<CategoryModel> _getFilteredCategories(AdminProvider adminProvider) {
    final categories = adminProvider.allCategories;
    switch (_selectedFilter) {
      case "All":
        return categories;
      case "Active":
        return categories.where((c) => c.isActive ?? false).toList();
      case "Inactive":
        return categories.where((c) => !(c.isActive ?? false)).toList();
      default:
        return categories;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    if (adminProvider.isLoadingCategories) {
      return Center(
        child: CircularProgressIndicator(color: MyColors.primaryColor),
      );
    }

    if (adminProvider.categoriesError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.red.shade300, size: 48),
            const SizedBox(height: 12),
            Text(
              adminProvider.categoriesError!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AdminProvider>().loadCategories(),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                elevation: 0,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final categories = _getFilteredCategories(adminProvider);

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              "No categories yet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 6),
            const Text(
              "Add your first category to get started",
              style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: List.generate(_filters.length, (index) {
              final isSelected = _selectedFilter == _filters[index];
              return Padding(
                padding: EdgeInsets.only(right: index < _filters.length - 1 ? 8 : 0),
                child: _FilterChip(
                  label: _filters[index],
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedFilter = _filters[index]),
                ),
              );
            }),
          ),
        ),
        // Categories list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(
                category: category,
                onEdit: widget.onEdit,
                onDeactivate: widget.onDeactivate,
                onReactivate: widget.onReactivate,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ItemsTab extends StatefulWidget {
  final Function(ItemModel) onEdit;
  final Function(ItemModel) onDeactivate;
  final Function(ItemModel) onReactivate;

  const _ItemsTab({
    required this.onEdit,
    required this.onDeactivate,
    required this.onReactivate,
  });

  @override
  State<_ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<_ItemsTab> {
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Available", "Unavailable"];

  List<ItemModel> _getFilteredItems(AdminProvider adminProvider) {
    final items = adminProvider.allItems;
    switch (_selectedFilter) {
      case "All":
        return items;
      case "Available":
        return items.where((i) => i.isAvailable ?? false).toList();
      case "Unavailable":
        return items.where((i) => !(i.isAvailable ?? false)).toList();
      default:
        return items;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    if (adminProvider.isLoadingItems) {
      return Center(
        child: CircularProgressIndicator(color: MyColors.primaryColor),
      );
    }

    if (adminProvider.itemsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.red.shade300, size: 48),
            const SizedBox(height: 12),
            Text(
              adminProvider.itemsError!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AdminProvider>().loadItems(),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                elevation: 0,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final items = _getFilteredItems(adminProvider);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              "No items yet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 6),
            const Text(
              "Add your first item to get started",
              style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: List.generate(_filters.length, (index) {
              final isSelected = _selectedFilter == _filters[index];
              return Padding(
                padding: EdgeInsets.only(right: index < _filters.length - 1 ? 8 : 0),
                child: _FilterChip(
                  label: _filters[index],
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedFilter = _filters[index]),
                ),
              );
            }),
          ),
        ),
        // Items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _ItemCard(
                item: item,
                onEdit: widget.onEdit,
                onDeactivate: widget.onDeactivate,
                onReactivate: widget.onReactivate,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final Function(CategoryModel) onEdit;
  final Function(CategoryModel) onDeactivate;
  final Function(CategoryModel) onReactivate;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDeactivate,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = category.isActive ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive
                  ? MyColors.primaryColor.withOpacity(0.10)
                  : Colors.grey.shade400.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.category_rounded,
              color: isActive ? MyColors.primaryColor : Colors.grey.shade500,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name ?? "Unnamed Category",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isActive ? const Color(0xFF1A1A1A) : Colors.grey.shade600,
                  ),
                ),
                if (category.description != null && category.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    category.description!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 20),
                onPressed: () => onEdit(category),
                tooltip: "Edit",
                color: const Color(0xFF1976D2),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
              IconButton(
                icon: Icon(
                  isActive ? Icons.block_rounded : Icons.check_circle_rounded,
                  size: 20,
                ),
                onPressed: () => isActive ? onDeactivate(category) : onReactivate(category),
                tooltip: isActive ? "Deactivate" : "Reactivate",
                color: isActive ? const Color(0xFFF9A825) : const Color(0xFF00A056),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF00A056).withOpacity(0.1)
                  : const Color(0xFF888888).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? "Active" : "Inactive",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: (category.isActive ?? false)
                    ? const Color(0xFF00A056)
                    : const Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ItemModel item;
  final Function(ItemModel) onEdit;
  final Function(ItemModel) onDeactivate;
  final Function(ItemModel) onReactivate;

  const _ItemCard({
    required this.item,
    required this.onEdit,
    required this.onDeactivate,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = (item.stockQuantity ?? 0) < 10;
    final isAvailable = item.isAvailable ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item image or placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isAvailable
                  ? MyColors.primaryColor.withOpacity(0.10)
                  : Colors.grey.shade400.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isAvailable ? Colors.transparent : Colors.grey,
                        BlendMode.srcIn,
                      ),
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fastfood_rounded,
                            color: isAvailable
                                ? MyColors.primaryColor.withOpacity(0.60)
                                : Colors.grey.shade500,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  )
                : Icon(
                    Icons.fastfood_rounded,
                    color: isAvailable
                        ? MyColors.primaryColor.withOpacity(0.60)
                        : Colors.grey.shade500,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "Unnamed Item",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isAvailable ? const Color(0xFF1A1A1A) : Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Text(
                      "₹${item.price?.toStringAsFixed(0) ?? "0"}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: MyColors.primaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isLowStock
                            ? const Color(0xFFE53935).withOpacity(0.1)
                            : const Color(0xFF00A056).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Stock: ${item.stockQuantity ?? 0}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isLowStock
                              ? const Color(0xFFE53935)
                              : const Color(0xFF00A056),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (item.isAvailable ?? false)
                            ? const Color(0xFF00A056).withOpacity(0.1)
                            : const Color(0xFF888888).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (item.isAvailable ?? false) ? "Available" : "Unavailable",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: (item.isAvailable ?? false)
                              ? const Color(0xFF00A056)
                              : const Color(0xFF888888),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 20),
                onPressed: () => onEdit(item),
                tooltip: "Edit",
                color: const Color(0xFF1976D2),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
              IconButton(
                icon: Icon(
                  isAvailable ? Icons.block_rounded : Icons.check_circle_rounded,
                  size: 20,
                ),
                onPressed: () => isAvailable ? onDeactivate(item) : onReactivate(item),
                tooltip: isAvailable ? "Deactivate" : "Reactivate",
                color: isAvailable ? const Color(0xFFF9A825) : const Color(0xFF00A056),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? MyColors.primaryColor
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}

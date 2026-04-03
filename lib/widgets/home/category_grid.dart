import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../constants/my_colors.dart";
import "../../models/category_model.dart";
import "../../services/category_service.dart";
import "/utils/my_logger.dart";

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final CategoryService _service = CategoryService();
  late Future<List<CategoryModel>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _service.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  "No categories available",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        }

        final categories = snapshot.data!;

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.82,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final category = categories[index];

              return CategoryCard(category: category);
            },
            childCount: categories.length,
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({ super.key, required this.category });

  @override
  Widget build(BuildContext context) {
    final accentColor = MyColors.primaryColor;

    return GestureDetector(
      onTap: () {
        context.push("/items/${category.categoryId}",extra: {
          "categoryName": category.name
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Icon Area ──────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _fallbackIcon(category.name ?? ""),
                    size: 48,
                    color: accentColor,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    category.description ?? "",
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8A8A8A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _fallbackIcon(String name) {
    final lower = name.toLowerCase();

    if (lower.contains("beverage")) return Icons.local_cafe_rounded;
    if (lower.contains("snack")) return Icons.bakery_dining_rounded;
    if (lower.contains("meal")) return Icons.restaurant_rounded;
    if (lower.contains("tiffin")) return Icons.breakfast_dining_rounded;
    if (lower.contains("dessert")) return Icons.cake_rounded;
    if (lower.contains("stationery")) return Icons.edit_note_rounded;

    return Icons.fastfood_rounded;
  }
}

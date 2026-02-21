import "package:flutter/material.dart";
import "../../../constants/my_colors.dart";

class MenuItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class ProfileMenuCard extends StatelessWidget {
  final List<MenuItemData> items;

  const ProfileMenuCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: MyColors.primaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFCCCCCC),
                ),
                onTap: item.onTap,
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Divider(height: 1, color: Color(0xFFF5F5F5)),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

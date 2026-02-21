import "package:flutter/material.dart";
import "../../../constants/my_colors.dart";

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        "Logout",
        style: TextStyle(
          color: MyColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text("Are you sure you want to logout?"),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

      ],
    ),
  );
}

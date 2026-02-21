import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../constants/my_colors.dart";
import "../../providers/user_provider.dart";

Widget buildTopBar({ required BuildContext context, required Function(int) onNavTap }) {
  final user = context.watch<UserProvider>().user;
  final String userName = user?.name ?? "Guest";

  return Container(
    padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
    color: const Color(0xFFF4F6F4),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning, $userName",
                style: TextStyle(
                  fontSize: 13,
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "What are you craving?",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

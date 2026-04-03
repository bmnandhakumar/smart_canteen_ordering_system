import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/widgets/app_loader.dart";
import "../../providers/user_provider.dart";
import "../widgets/profile/profile_header.dart";
import "../widgets/profile/profile_menu_section.dart";
import "../widgets/profile/profile_stats.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 16),
              const ProfileStats(),
              const SizedBox(height: 20),
              const ProfileMenuSection(),
            ],
          ),
        ),
      ),
    );
  }
}

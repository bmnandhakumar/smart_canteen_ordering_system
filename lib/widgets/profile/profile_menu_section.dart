import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../../services/auth_service.dart";
import "profile_menu_card.dart";
import "logout_dialog.dart";

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ─────────── ACCOUNT SECTION ───────────
          const _SectionTitle(title: "Account"),
          ProfileMenuCard(
            items: [
              MenuItemData(
                icon: Icons.person_outline_rounded,
                label: "Edit Profile",
                onTap: () {
                  context.push("/edit-profile");
                },
              ),
              MenuItemData(
                icon: Icons.lock_outline_rounded,
                label: "Change Password",
                onTap: () {
                  context.push("/change-password");
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ─────────── PREFERENCES SECTION ───────────
          const _SectionTitle(title: "Preferences"),
          ProfileMenuCard(
            items: [
              MenuItemData(
                icon: Icons.help_outline_rounded,
                label: "Help & Support",
                onTap: () {
                  context.push("/help-support");
                },
              ),
              MenuItemData(
                icon: Icons.info_outline_rounded,
                label: "About",
                onTap: () {
                  context.push("/about");
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ─────────── LOGOUT ───────────
          _buildLogout(context),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.logout_rounded,
            color: Color(0xFFE53935),
            size: 20,
          ),
        ),
        title: const Text(
          "Log Out",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14.5,
            color: Color(0xFFE53935),
          ),
        ),
        onTap: () async {
          final shouldLogout = await showLogoutDialog(context);
          if (shouldLogout == true) {
            await AuthService.instance.signOut();
          }
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF888888),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

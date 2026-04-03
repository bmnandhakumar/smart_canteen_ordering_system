import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
// import "package:url_launcher/url_launcher.dart";
import "../constants/my_colors.dart";

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "About",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Logo & Name
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.restaurant_rounded,
                    size: 40,
                    color: MyColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Smart Canteen",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Build 100",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Smart Canteen is your convenient solution for ordering food on campus. "
                  "Skip the queue, order ahead, and enjoy fresh meals without the wait. "
                  "Built with care for students, by students.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF555555),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Features
          const _SectionTitle(title: "Features"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildFeatureTile(
                  Icons.shopping_bag_outlined,
                  "Quick Ordering",
                  "Browse, select, and order in seconds",
                ),
                const Divider(height: 1, indent: 60),
                _buildFeatureTile(
                  Icons.people_outline_rounded,
                  "Live Crowd Monitor",
                  "Check canteen occupancy in real-time",
                ),
                const Divider(height: 1, indent: 60),
                _buildFeatureTile(
                  Icons.notifications_outlined,
                  "Order Updates",
                  "Get notified when your order is ready",
                ),
                const Divider(height: 1, indent: 60),
                _buildFeatureTile(
                  Icons.history_rounded,
                  "Order History",
                  "Track your past orders and favorites",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Social Links
          const _SectionTitle(title: "Connect With Us"),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  Icons.language_rounded,
                  "Website",
                      () => _launchURL("https://smartcanteen.com"),
                ),
                _buildSocialButton(
                  Icons.email_outlined,
                  "Email",
                      () => _launchURL("mailto:info@smartcanteen.com"),
                ),
                _buildSocialButton(
                  Icons.phone_outlined,
                  "Call",
                      () => _launchURL("tel:+911234567890"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Legal
          const _SectionTitle(title: "Legal"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildLegalTile(
                  "Privacy Policy",
                      () => _launchURL("https://smartcanteen.com/privacy"),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildLegalTile(
                  "Terms of Service",
                      () => _launchURL("https://smartcanteen.com/terms"),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildLegalTile(
                  "Licenses",
                      () => showLicensePage(context: context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Footer
          const Center(
            child: Column(
              children: [
                Text(
                  "Made with ❤️ by the Smart Canteen Team",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "© 2024 Smart Canteen. All rights reserved.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: MyColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: MyColors.primaryColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF888888),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      IconData icon,
      String label,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: MyColors.primaryColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Color(0xFFCCCCCC),
      ),
      onTap: onTap,
    );
  }

  Future<void> _launchURL(String url) async {
    // final uri = Uri.parse(url);
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri, mode: LaunchMode.externalApplication);
    // }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
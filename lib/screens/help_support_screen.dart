import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../constants/my_colors.dart";

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          "Help & Support",
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
          // Contact Cards
          _buildContactCard(
            icon: Icons.email_outlined,
            title: "Email Us",
            subtitle: "support@smartcanteen.com",
            color: MyColors.primaryColor,
            onTap: () => _launchEmail("support@smartcanteen.com"),
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.phone_outlined,
            title: "Call Us",
            subtitle: "+91 1234567890",
            color: const Color(0xFF2196F3),
            onTap: () => _launchPhone("+911234567890"),
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.chat_bubble_outline_rounded,
            title: "WhatsApp",
            subtitle: "Chat with us",
            color: const Color(0xFF25D366),
            onTap: () => _launchWhatsApp("+911234567890"),
          ),

          const SizedBox(height: 24),

          // FAQ Section
          const _SectionTitle(title: "Frequently Asked Questions"),
          const _FAQSection(),

          const SizedBox(height: 24),

          // Operating Hours
          const _SectionTitle(title: "Operating Hours"),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildInfoRow("Monday - Friday", "8:00 AM - 6:00 PM"),
                const Divider(height: 24),
                _buildInfoRow("Saturday", "9:00 AM - 4:00 PM"),
                const Divider(height: 24),
                _buildInfoRow("Sunday", "Closed"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MyColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail(String email) async {
    // final uri = Uri.parse("mailto:$email?subject=Support Request");
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // }
  }

  Future<void> _launchPhone(String phone) async {
    // final uri = Uri.parse("tel:$phone");
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // }
  }

  Future<void> _launchWhatsApp(String phone) async {
    // final uri = Uri.parse("https://wa.me/$phone");
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

class _FAQSection extends StatelessWidget {
  const _FAQSection();

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "How do I place an order?",
        "answer":
        "Browse categories, select items, adjust quantities, and tap 'View Cart' to complete your order."
      },
      {
        "question": "What payment methods are accepted?",
        "answer":
        "We accept UPI, credit/debit cards, and cash payments at the counter."
      },
      {
        "question": "Can I cancel or modify my order?",
        "answer":
        "Orders can be cancelled within 2 minutes of placement. Contact support for modifications."
      },
      {
        "question": "How long does order preparation take?",
        "answer":
        "Most orders are ready in 10-15 minutes. You'll receive a notification when it's ready."
      },
      {
        "question": "Is there a minimum order value?",
        "answer": "No minimum order value. Order as little or as much as you need."
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          final isLast = index == faqs.length - 1;

          return Column(
            children: [
              _FAQItem(
                question: faq["question"]!,
                answer: faq["answer"]!,
              ),
              if (!isLast)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          widget.question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        trailing: Icon(
          _isExpanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: MyColors.primaryColor,
          size: 24,
        ),
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              widget.answer,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
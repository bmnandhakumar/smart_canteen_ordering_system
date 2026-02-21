import "package:flutter/material.dart";
import "../../constants/my_colors.dart";

enum CrowdLevel { low, moderate, busy }

CrowdLevel crowdLevelFromString(String level) {
  switch (level.toUpperCase()) {
    case "HIGH":
    case "BUSY":
      return CrowdLevel.busy;
    case "MODERATE":
    case "MEDIUM":
      return CrowdLevel.moderate;
    default:
      return CrowdLevel.low;
  }
}

class CrowdMonitorBanner extends StatelessWidget {
  final CrowdLevel crowdLevel;
  final int totalPeopleInCanteen;
  final bool isLoading;

  const CrowdMonitorBanner({
    super.key,
    required this.crowdLevel,
    required this.totalPeopleInCanteen,
    this.isLoading = false,
  });

  Color get _levelColor {
    switch (crowdLevel) {
      case CrowdLevel.low:
        return const Color(0xFF2E7D32);
      case CrowdLevel.moderate:
        return const Color(0xFFF9A825);
      case CrowdLevel.busy:
        return const Color(0xFFE53935);
    }
  }

  String get _levelLabel {
    switch (crowdLevel) {
      case CrowdLevel.low:
        return "Low";
      case CrowdLevel.moderate:
        return "Moderate";
      case CrowdLevel.busy:
        return "Busy";
    }
  }

  IconData get _levelIcon {
    switch (crowdLevel) {
      case CrowdLevel.low:
        return Icons.sentiment_satisfied_alt_rounded;
      case CrowdLevel.moderate:
        return Icons.sentiment_neutral_rounded;
      case CrowdLevel.busy:
        return Icons.sentiment_very_dissatisfied_rounded;
    }
  }

  String get _waitingTime {
    switch (crowdLevel) {
      case CrowdLevel.low:
        return "< 2 mins";
      case CrowdLevel.moderate:
        return "5–10 mins";
      case CrowdLevel.busy:
        return "15–20 mins";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // ── Green header strip ──────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColors.primaryColor,
                    MyColors.primaryColor.withOpacity(0.80),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sensors_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "Crowd Monitoring",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _PulseDot(isLoading: isLoading),
                        const SizedBox(width: 5),
                        Text(
                          isLoading ? "Updating..." : "Live",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Stats row ───────────────────────────────────────
            isLoading
                ? const _LoadingStats()
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: _levelIcon,
                      iconColor: _levelColor,
                      label: "Crowd Level",
                      value: _levelLabel,
                      valueColor: _levelColor,
                    ),
                  ),
                  _VertDivider(),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.access_time_rounded,
                      iconColor: const Color(0xFF1565C0),
                      label: "Waiting Time",
                      value: _waitingTime,
                      valueColor: const Color(0xFF1565C0),
                    ),
                  ),
                  _VertDivider(),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.people_outline_rounded,
                      iconColor: const Color(0xFF6A1B9A),
                      label: "In Canteen",
                      value: "$totalPeopleInCanteen",
                      valueColor: const Color(0xFF6A1B9A),
                    ),
                  ),
                ],
              ),
            ),

            // ── Footer strip ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAF8),
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.update_rounded,
                      size: 14, color: Color(0xFF999999)),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF666666)),
                      children: [
                        const TextSpan(text: "Live · "),
                        TextSpan(
                          text: isLoading
                              ? "—"
                              : "$totalPeopleInCanteen people",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const TextSpan(text: " in canteen now"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _TrafficLight(
                      label: "Low", color: const Color(0xFF2E7D32)),
                  const SizedBox(width: 4),
                  _TrafficLight(
                      label: "Moderate", color: const Color(0xFFF9A825)),
                  const SizedBox(width: 4),
                  _TrafficLight(
                      label: "Busy", color: const Color(0xFFE53935)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _PulseDot extends StatefulWidget {
  final bool isLoading;
  const _PulseDot({required this.isLoading});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFF69F0AE),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _LoadingStats extends StatelessWidget {
  const _LoadingStats();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Fetching crowd data...",
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: Color(0xFF888888),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 52,
      color: const Color(0xFFEEEEEE),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _TrafficLight extends StatelessWidget {
  final String label;
  final Color color;
  const _TrafficLight({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
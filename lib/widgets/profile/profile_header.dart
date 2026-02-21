import "package:flutter/material.dart";
import "../../../models/user_model.dart";
import "../../../utils/user_formatter.dart";
import "../../../constants/my_colors.dart";

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryColor,
            MyColors.primaryColor.withOpacity(0.80),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
        child: Column(
          children: [
            _buildAvatar(),
            const SizedBox(height: 14),
            Text(
              user.name ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email ?? "",
              style: TextStyle(
                color: Colors.white.withOpacity(0.80),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 6),
            _buildAcademicChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
      ),
      child: Icon(
        Icons.person_rounded,
        size: 44,
        color: MyColors.primaryColor,
      ),
    );
  }

  Widget _buildAcademicChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        UserFormatter.formatAcademicInfo(
          yearOfJoining: user.yearOfJoining ?? 2022,
          departmentName: user.departmentName ?? "IT",
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class UserFormatter {
  UserFormatter._();

  static String formatAcademicInfo({ required int yearOfJoining, required String departmentName }) {
    final currentYear = DateTime.now().year;
    final currentAcademicYear = currentYear - yearOfJoining;
    final yearText = _getYearLabel(currentAcademicYear);

    return "🎓 $yearText · $departmentName";
  }

  static String _getYearLabel(int year) {
    if (year == 1) return "1st Year";
    if (year == 2) return "2nd Year";
    if (year == 3) return "3rd Year";
    if (year == 4) return "4th Year";
    return "$year Year";
  }
}

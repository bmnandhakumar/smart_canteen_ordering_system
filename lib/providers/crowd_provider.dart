import "package:flutter/material.dart";
import "package:smart_canteen_ordering_system/services/crowd_service.dart";

class CrowdProvider extends ChangeNotifier {
  final CrowdService _service = CrowdService.instance;

  int _people = 0;
  String _level = "LOW";
  bool _isLoading = false;

  // Getters
  int get people => _people;
  String get level => _level;
  bool get isLoading => _isLoading;

  // Load crowd data from API
  Future<void> loadCrowdData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _service.getCrowdLevel();
      _people = data["people"] as int? ?? 0;
      _level = data["level"] as String? ?? "LOW";
    } catch (e) {
      _people = 0;
      _level = "LOW";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update crowd data (for admin use)
  Future<bool> updateCrowdData(int people, String level) async {
    try {
      final success = await _service.updateCrowdLevel({
        "people": people,
        "level": level,
      });
      if (success) {
        await loadCrowdData();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  // Get level color for UI
  Color getLevelColor() {
    switch (_level.toUpperCase()) {
      case "LOW":
        return const Color(0xFF00A056);
      case "MEDIUM":
        return const Color(0xFFF9A825);
      case "HIGH":
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF888888);
    }
  }
}

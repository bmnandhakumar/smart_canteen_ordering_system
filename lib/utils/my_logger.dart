import "package:flutter/material.dart";

void log(String message) {
  final DateTime now = DateTime.now();

  final String time =
      "${now.hour.toString().padLeft(2, "0")}:"
      "${now.minute.toString().padLeft(2, "0")}:"
      "${now.second.toString().padLeft(2, "0")}";

  debugPrint("🏎️ [$time] $message");
}

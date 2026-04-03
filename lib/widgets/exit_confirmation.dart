import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../constants/my_colors.dart";

class ExitConfirmationWrapper extends StatefulWidget {
  final Widget child;

  const ExitConfirmationWrapper({super.key, required this.child});

  @override
  State<ExitConfirmationWrapper> createState() =>
      _ExitConfirmationWrapperState();
}

class _ExitConfirmationWrapperState extends State<ExitConfirmationWrapper> {
  DateTime? _lastBackPressed;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showExitPrompt() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => _ExitPromptOverlay(onDismiss: _removeOverlay),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _removeOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 1)) {
          _lastBackPressed = now;
          _showExitPrompt();
          return;
        }

        SystemNavigator.pop();
      },
      child: widget.child,
    );
  }
}

class _ExitPromptOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const _ExitPromptOverlay({required this.onDismiss});

  @override
  State<_ExitPromptOverlay> createState() => _ExitPromptOverlayState();
}

class _ExitPromptOverlayState extends State<_ExitPromptOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: MyColors.primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.exit_to_app_rounded,
                        color: MyColors.primaryColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Press back again to exit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";
import "../constants/my_colors.dart";
import "../providers/user_provider.dart";
import "../widgets/login_card.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = "";

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      UserCredential credential =await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String email = credential.user!.email!;
      await context.read<UserProvider>().fetchUserByEmail(email);

    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _parseFirebaseError(e.code);
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    // TODO: Navigate to forgot password screen
  }

  String _parseFirebaseError(String code) {
    switch (code) {
      case "user-not-found":
        return "No account found with this email.";
      case "wrong-password":
        return "Incorrect password. Please try again.";
      case "invalid-email":
        return "Please enter a valid email address.";
      case "user-disabled":
        return "This account has been disabled.";
      case "too-many-requests":
        return "Too many attempts. Please try again later.";
      default:
        return "Login failed. Please check your credentials.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  LoginCard(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    onLogin: _login,
                    onForgotPassword: _forgotPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.primaryColor,
            MyColors.primaryColor.withValues(alpha: 0.82),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: _DecorCircle(120, Colors.white.withValues(alpha: 0.06)),
          ),
          Positioned(
            top: 20,
            right: 60,
            child: _DecorCircle(60, Colors.white.withValues(alpha: 0.05)),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: _DecorCircle(90, Colors.white.withValues(alpha: 0.05)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 52, 28, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App icon + college name
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          "assets/icons/app_icon.png",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.school_rounded,
                              color: MyColors.primaryColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "NEC",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "Smart Canteen",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.88),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Sign in to order your favourite meals",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private helper widget ─────────────────────────────────────────────────────

class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorCircle(this.size, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
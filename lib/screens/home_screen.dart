import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:smart_canteen_ordering_system/providers/user_provider.dart";
import "../providers/cart_provider.dart";
import "../providers/order_provider.dart";
import "../services/crowd_service.dart";
import "../widgets/home/bottom_nav_bar.dart";
import "../widgets/home/crowd_monitor_banner.dart";
import "../widgets/home/category_grid.dart";
import "../widgets/floating_cart_button.dart";
import "../widgets/home/top_bar.dart";
import "orders_screen.dart";
import "cart_screen.dart";
import "profile_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;
  bool _ordersLoaded = false;

  final CrowdService _crowdService = CrowdService.instance;
  CrowdLevel _crowdLevel = CrowdLevel.low;
  int _totalPeople = 0;
  bool _crowdLoading = true;
  Timer? _pollingTimer;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _fetchCrowdData();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 11),
          (_) => _fetchCrowdData(),
    );

    // Load cart after first frame (when context is available)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().loadCart(context.read<UserProvider>().user!.userId!);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchCrowdData() async {
    if (!mounted) return;
    setState(() => _crowdLoading = true);

    try {
      final data = await _crowdService.getCrowdLevel();

      if (!mounted) return;
      setState(() {
        _totalPeople = (data["people"] as num?)?.toInt() ?? 0;
        _crowdLevel = crowdLevelFromString((data["level"] as String?) ?? "LOW");
        _crowdLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _totalPeople = 0;
        _crowdLevel = CrowdLevel.low;
        _crowdLoading = false;
      });
    }
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);

    // Load orders when switching to Orders tab
    if (index == 1 && !_ordersLoaded) {
      _loadOrders();
    }
  }

  Future<void> _loadOrders() async {
    final userId = context.read<UserProvider>().user!.userId!;
    await context.read<OrderProvider>().loadOrders(userId);
    if (mounted) {
      setState(() => _ordersLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalQuantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeBody(),
          const OrdersScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        cartItemCount: cartCount,
        onTap: _onNavTap,
      ),
      floatingActionButton: _currentNavIndex < 2
          ? FloatingCartButton(onTap: () => _onNavTap(2))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHomeBody() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: buildTopBar(
                context: context,
                onNavTap: _onNavTap,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: CrowdMonitorBanner(
                  crowdLevel: _crowdLevel,
                  totalPeopleInCanteen: _totalPeople,
                  isLoading: _crowdLoading,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: Text(
                  "Choose a Category",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: CategoryGrid(),
            ),
          ],
        ),
      ),
    );
  }
}

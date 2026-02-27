import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/home_icon_grid_widget.dart';

/// Detail screen for a hub with more than 4 items: carousel banner at top, then full grid.
class HubDetailScreen extends StatefulWidget {
  const HubDetailScreen({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<HomeIconGridItem> items;

  @override
  State<HubDetailScreen> createState() => _HubDetailScreenState();
}

class _HubDetailScreenState extends State<HubDetailScreen> {
  late PageController _bannerController;
  static const int _bannerCount = 3;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 12),
          _BannerCarousel(controller: _bannerController),
          const SizedBox(height: 16),
          _DotIndicator(controller: _bannerController, itemCount: _bannerCount),
          const SizedBox(height: 24),
          HomeIconGrid(items: widget.items, columns: 4),
        ],
      ),
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  final PageController controller;

  const _BannerCarousel({required this.controller});

  static final List<MapEntry<List<Color>, String>> _banners = [
    (MapEntry([
      Color(0xFF1565C0),
      Color(0xFF1976D2),
      Color(0xFF1E88E5),
    ], 'Special offers this week')),
    (MapEntry([
      Color(0xFF2E7D32),
      Color(0xFF388E3C),
      Color(0xFF43A047),
    ], 'Save more on recharges')),
    (MapEntry([
      Color(0xFF6A1B9A),
      Color(0xFF7B1FA2),
      Color(0xFF8E24AA),
    ], 'Exclusive deals for you')),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: controller,
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final entry = _banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: entry.key,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    entry.value,
                    style: GoogleFonts.mulish(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final PageController controller;
  final int itemCount;

  const _DotIndicator({required this.controller, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? controller.page ?? 0 : 0.0;
        final current = page.round().clamp(0, itemCount - 1);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (i) {
            final isActive = i == current;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryBlue
                    : AppColors.textSecondary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Promotional banner at top of home: car insurance offer with CTA.
/// Reddish-brown gradient, headline, "Insure now" button, and disclaimer.
class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key, this.onInsureTap, this.onHelpTap});

  final VoidCallback? onInsureTap;
  final VoidCallback? onHelpTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B4513), Color(0xFFA0522D), Color(0xFFCD5C5C)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Save up to ₹3000* On Car Insurance Purchase',
                          style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Material(
                          color: const Color(0xFF3E2723),
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            onTap: onInsureTap ?? () {},
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Insure now',
                                    style: GoogleFonts.mulish(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _BannerIllustration(),
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: IconButton(
                onPressed: onHelpTap ?? () {},
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white70,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(6),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 10,
              child: Text(
                '*T&C Apply | BN/2218',
                style: GoogleFonts.mulish(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for shield + car illustration on the right side of the banner.
class _BannerIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shield_rounded,
            size: 56,
            color: Colors.lightBlue.shade200.withValues(alpha: 0.9),
          ),
          Positioned(
            bottom: 8,
            child: Icon(
              Icons.directions_car_rounded,
              size: 40,
              color: Colors.orange.shade300,
            ),
          ),
          Positioned(
            top: 12,
            right: 4,
            child: Icon(
              Icons.attach_money_rounded,
              size: 20,
              color: Colors.green.shade200,
            ),
          ),
          Positioned(
            top: 20,
            left: 2,
            child: Icon(
              Icons.attach_money_rounded,
              size: 16,
              color: Colors.green.shade200,
            ),
          ),
        ],
      ),
    );
  }
}

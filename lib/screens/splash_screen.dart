import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/permission_service.dart';
import '../widgets/permission_dialog.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    Timer(const Duration(milliseconds: 2200), () {
      _checkPermissionsAndProceed();
    });
  }

  void _checkPermissionsAndProceed() async {
    if (!mounted) return;

    final hasPermissions = await PermissionService().hasEssentialPermissions();

    if (hasPermissions) {
      _navigateToHome();
    } else {
      if (!mounted) return;
      // Prompt user with permission dialog & system popups on initial start
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PermissionDialog(
          onGranted: () {
            _navigateToHome();
          },
        ),
      );
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEF7F3),
              Color(0xFFE0F2EF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: -50,
                right: -50,
                child: Icon(
                  Icons.mosque,
                  size: 320,
                  color: primaryEmerald.withValues(alpha: 0.04),
                ),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryEmerald.withValues(alpha: 0.15),
                                    blurRadius: 35,
                                    spreadRadius: 8,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: accentGold.withValues(alpha: 0.12),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 110,
                                height: 110,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.mosque,
                                    size: 90,
                                    color: primaryEmerald,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 28),

                            Text(
                              'أَذَانُكِي',
                              style: GoogleFonts.amiri(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: accentGold,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Adzanku',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0A241C),
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryEmerald.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: primaryEmerald.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Text(
                                'Waktu Sholat & Alarm Azan Presisi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: primaryEmerald,
                                ),
                              ),
                            ),

                            const SizedBox(height: 48),

                            SizedBox(
                              width: 140,
                              child: LinearProgressIndicator(
                                backgroundColor: primaryEmerald.withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(primaryEmerald),
                                borderRadius: BorderRadius.circular(10),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Versi 1.0.0 • Digital Era Edition',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF4A6B5D).withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// lib/screens/splash_screen.dart
//
// Mbuya — Splash / Landing Screen
// First screen users see. Animates in, then routes to
// LoginScreen or HomeScreen depending on auth state.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _clay      = Color(0xFFC47B3E);
const _clayDark  = Color(0xFF9B5E2A);
const _earthDeep = Color(0xFF3D2010);
const _earth     = Color(0xFF5C3317);
const _sand      = Color(0xFFF5ECD7);
const _textSoft  = Color(0xFFA88060);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Three staggered animations: logo, tagline, buttons
  late final AnimationController _logoCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _btnCtrl;

  late final Animation<double>  _logoScale;
  late final Animation<double>  _logoFade;
  late final Animation<Offset>  _taglineSlide;
  late final Animation<double>  _taglineFade;
  late final Animation<Offset>  _btnSlide;
  late final Animation<double>  _btnFade;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    );
    _taglineCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    );
    _btnCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOutCubic));
    _taglineFade = CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut);

    _btnSlide = Tween<Offset>(
      begin: const Offset(0, 0.4), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOutCubic));
    _btnFade = CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOut);

    // Stagger the three animations
    _logoCtrl.forward().then((_) {
      _taglineCtrl.forward().then((_) {
        _btnCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _taglineCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_earthDeep, _earth, Color(0xFF7A4520), _clay],
            ),
          ),
          child: Stack(
            children: [
              // ── Decorative background circles ──
              Positioned(
                top: -60, right: -60,
                child: Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: 100, left: -80,
                child: Container(
                  width: 240, height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                right: -40,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _clay.withOpacity(0.2),
                  ),
                ),
              ),

              // ── Main content ──
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      // ── Logo ──
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Column(
                            children: [
                              // Icon box
                              Container(
                                width: 88, height: 88,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    '🍃',
                                    style: TextStyle(fontSize: 46),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // App name
                              const Text(
                                'Mbuya',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.5,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Tagline ──
                      FadeTransition(
                        opacity: _taglineFade,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: Column(
                            children: [
                              const Text(
                                'Travel Like Your Grandparent\nWould Teach You',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.4,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Discover nature, markets & local stories\nas you travel across Malawi.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.65),
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // ── Feature pills ──
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: [
                                  _pill('📍 Live route discovery'),
                                  _pill('🐘 Wildlife alerts'),
                                  _pill('🛒 Local marketplace'),
                                  _pill('🧓 Mbuya narrates'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // ── Buttons ──
                      FadeTransition(
                        opacity: _btnFade,
                        child: SlideTransition(
                          position: _btnSlide,
                          child: Column(
                            children: [
                              // Get Started (Sign Up)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/signup'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: _clayDark,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Sign In
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/login'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    side: BorderSide(
                                      color:
                                      Colors.white.withOpacity(0.4),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              Text(
                                'Made in Malawi 🇲🇼',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
// lib/screens/profile_screen.dart
//
// Mbuya — Profile & Subscription Screen
// Fixed floating stats card using Stack + Positioned

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  COLOURS
// ─────────────────────────────────────────────
const _clay       = Color(0xFFC47B3E);
const _clayDark   = Color(0xFF9B5E2A);
const _earth      = Color(0xFF5C3317);
const _earthDeep  = Color(0xFF3D2010);
const _cream      = Color(0xFFFEFAF4);
const _sandLight  = Color(0xFFFBF7F0);
const _textMid    = Color(0xFF6B4C33);
const _textSoft   = Color(0xFFA88060);
const _green      = Color(0xFF2E7D32);
const _greenLight = Color(0xFFE8F5E9);

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: _textSoft,
        letterSpacing: 0.8,
      ),
    ),
  );

  static Widget _greenBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: _greenLight,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text,
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, color: _green)),
  );

  static Widget _addBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF3E0),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _clay.withOpacity(0.3)),
    ),
    child: const Text('+ Link',
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, color: _clay)),
  );

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _sandLight,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                // ── Header + floating stats ──────────────
                SliverToBoxAdapter(child: _ProfileHeaderWithStats()),

                // ── Body ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── My Account ──
                        _sectionLabel('My Account'),
                        _MenuItem(
                          icon: Icons.map_rounded,
                          iconBg: const Color(0xFFFFF3E0),
                          iconColor: _clay,
                          title: 'Journey History',
                          subtitle: '14 completed routes',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.favorite_rounded,
                          iconBg: const Color(0xFFFFEBEE),
                          iconColor: const Color(0xFFC62828),
                          title: 'Saved Places',
                          subtitle: '6 bookmarked spots',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.star_rounded,
                          iconBg: const Color(0xFFFFF8E1),
                          iconColor: const Color(0xFFF9A825),
                          title: 'My Reviews',
                          subtitle: '3 reviews written',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.shopping_bag_rounded,
                          iconBg: _greenLight,
                          iconColor: _green,
                          title: 'Order History',
                          subtitle: '2 past orders',
                          onTap: () {},
                        ),

                        // ── Subscription ──
                        _sectionLabel('Subscription'),
                        const _SubscriptionCard(),

                        // ── Payment Methods ──
                        _sectionLabel('Payment Methods'),
                        _MenuItem(
                          icon: Icons.phone_android_rounded,
                          iconBg: const Color(0xFFE3F2FD),
                          iconColor: const Color(0xFF1565C0),
                          title: 'Airtel Money',
                          subtitle: '+265 99x xxx xxxx · Active',
                          trailing: _greenBadge('Default'),
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.phone_android_rounded,
                          iconBg: _greenLight,
                          iconColor: _green,
                          title: 'TNM Mpamba',
                          subtitle: 'Not linked',
                          trailing: _addBadge(),
                          onTap: () {},
                        ),

                        // ── Settings ──
                        _sectionLabel('Settings'),
                        _MenuItem(
                          icon: Icons.notifications_rounded,
                          iconBg: const Color(0xFFF3E5F5),
                          iconColor: const Color(0xFF6A1B9A),
                          title: 'Notifications',
                          subtitle: 'Journey alerts, market updates',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.language_rounded,
                          iconBg: const Color(0xFFE0F7FA),
                          iconColor: const Color(0xFF00838F),
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.shield_rounded,
                          iconBg: const Color(0xFFFBE9E7),
                          iconColor: const Color(0xFFBF360C),
                          title: 'Privacy & Data',
                          subtitle: 'Manage your data',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          iconBg: const Color(0xFFF1F8E9),
                          iconColor: const Color(0xFF33691E),
                          title: 'Help & Support',
                          subtitle: 'FAQs, contact us',
                          onTap: () {},
                        ),

                        const SizedBox(height: 16),
                        _SignOutButton(),
                        const SizedBox(height: 12),

                        Center(
                          child: Text(
                            'Mbuya v1.0.0 · Made in Malawi 🇲🇼',
                            style: TextStyle(
                              fontSize: 11,
                              color: _textSoft.withOpacity(0.6),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER + STATS COMBINED
//  Stack gives real layout overlap — no Transform.translate clipping
// ─────────────────────────────────────────────
class _ProfileHeaderWithStats extends StatelessWidget {
  // Rendered height of the stats card
  static const double _cardHeight  = 88.0;
  // How far the card climbs up into the header
  static const double _overlap     = 28.0;
  // The space below the header that holds the bottom part of the card
  static const double _belowHeader = _cardHeight - _overlap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Column: dark header  +  white gap below it
        Column(
          children: [
            // Header is told to leave extra bottom padding
            // so the Stack is tall enough for the card to sit in
            _ProfileHeader(extraBottomPadding: _belowHeader),

            // White spacer — this is the non-overlapping lower portion
            // of the stats card sitting below the header
            Container(height: _belowHeader, color: _sandLight),
          ],
        ),

        // Stats card pinned to the very bottom of the Stack
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: _StatsCard(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final double extraBottomPadding;
  const _ProfileHeader({this.extraBottomPadding = 0});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPad + 12,
        // 28 = the overlap amount; extraBottomPadding is the space
        // that pushes the Stack height down to fit the card bottom
        bottom: 28 + extraBottomPadding,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_earthDeep, _earth, Color(0xFF7A4520)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative glow top-right
          Positioned(
            right: -30, top: -20,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _clay.withOpacity(0.18),
              ),
            ),
          ),
          // Decorative glow bottom-left
          Positioned(
            left: -40, bottom: 0,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          // Main column
          Column(
            children: [

              // ── Top bar (logo + edit button) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Logo icon
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.25)),
                      ),
                      child: const Center(
                        child: Text('🍃', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Mbuya',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Avatar ──
              Stack(
                children: [
                  Container(
                    width: 78, height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        colors: [_clay, _clayDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'MM',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  // Online dot
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: _earthDeep, width: 2.5),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Name ──
              const Text(
                'Mark Mwanavina',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              // ── Plan badge ──
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _clay,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _clay.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🍃', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 5),
                    Text(
                      'Adventurer Plan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STATS CARD
// ─────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C1A0E).withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatItem(value: '14', label: 'Journeys'),
            _vDivider(),
            _StatItem(value: '89', label: 'Discoveries'),
            _vDivider(),
            _StatItem(value: '6',  label: 'Saved'),
            _vDivider(),
            _StatItem(value: '3',  label: 'Reviews'),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 1,
    margin: const EdgeInsets.symmetric(vertical: 16),
    color: _clay.withOpacity(0.12),
  );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _clayDark,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: _textSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  MENU ITEM
// ─────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData   icon;
  final Color      iconBg;
  final Color      iconColor;
  final String     title;
  final String     subtitle;
  final Widget?    trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: _clay.withOpacity(0.06),
          highlightColor: _clay.withOpacity(0.04),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _clay.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2C1A0E).withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 13),
                // Labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C1A0E),
                          )),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 12, color: _textSoft)),
                    ],
                  ),
                ),
                // Trailing
                trailing ??
                    Icon(Icons.chevron_right_rounded,
                        color: _textSoft.withOpacity(0.6), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SUBSCRIPTION CARD
// ─────────────────────────────────────────────
class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_earthDeep, _earth, Color(0xFF7A4520)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _earth.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Glow top-right
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _clay.withOpacity(0.15),
              ),
            ),
          ),
          // Glow bottom-left
          Positioned(
            left: -10, bottom: -10,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Badge + active pill
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _clay,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🍃', style: TextStyle(fontSize: 11)),
                          SizedBox(width: 5),
                          Text('Adventurer',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Text('Active',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF81C784),
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Price
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'MK 2,900',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text('/ month',
                          style: TextStyle(
                              fontSize: 13, color: Colors.white60)),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Renewal line
                Row(
                  children: [
                    Icon(Icons.refresh_rounded,
                        size: 13,
                        color: Colors.white.withOpacity(0.5)),
                    const SizedBox(width: 5),
                    Text(
                      'Renews 30 April 2026 · Airtel Money',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.55)),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Feature chips
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _chip('✅ Unlimited journeys'),
                    _chip('🛒 Marketplace access'),
                    _chip('📍 Live tracking'),
                    _chip('🔔 Proximity alerts'),
                  ],
                ),

                const SizedBox(height: 20),

                Divider(color: Colors.white.withOpacity(0.1), height: 1),

                const SizedBox(height: 16),

                // Buttons
                Row(
                  children: [
                    Expanded(child: _subBtn('Manage Plan',    filled: true,  onTap: () {})),
                    const SizedBox(width: 10),
                    Expanded(child: _subBtn('Upgrade to Pro', filled: false, onTap: () {})),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.10),
      borderRadius: BorderRadius.circular(20),
      border:
      Border.all(color: Colors.white.withOpacity(0.15)),
    ),
    child: Text(text,
        style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w500)),
  );

  Widget _subBtn(String label,
      {required bool filled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: filled ? _clay : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: filled ? _clay : Colors.white.withOpacity(0.3),
          ),
          boxShadow: filled
              ? [
            BoxShadow(
              color: _clay.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: filled ? Colors.white : Colors.white70,
              )),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SIGN OUT BUTTON
// ─────────────────────────────────────────────
class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFEBEE),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _confirm(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: Color(0xFFC62828), size: 18),
              SizedBox(width: 8),
              Text('Sign Out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC62828),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cream,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: const Text('Sign out?',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C1A0E),
            )),
        content: const Text(
          'You will need to sign in again to access your journeys and saved places.',
          style: TextStyle(fontSize: 14, color: _textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: _textSoft)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sign Out',
                style: TextStyle(
                  color: Color(0xFFC62828),
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}
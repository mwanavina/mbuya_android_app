// lib/screens/home_screen.dart
//
// Mbuya — Home Screen
// Matches the UI mockup: dark gradient header with Chichewa greeting,
// search bar, popular journey cards, filter chips, nearby POI list.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

// ── colours ──────────────────────────────────────────────────
const _clay      = Color(0xFFC47B3E);
const _clayDark  = Color(0xFF9B5E2A);
const _earthDeep = Color(0xFF3D2010);
const _earth     = Color(0xFF5C3317);
const _sandLight = Color(0xFFFBF7F0);
const _textSoft  = Color(0xFFA88060);
const _textMid   = Color(0xFF6B4C33);
const _white     = Colors.white;

// ── mock data ────────────────────────────────────────────────
const _journeys = [
  {
    'title':    'Lilongwe → Karonga',
    'duration': '8h drive',
    'stops':    '24 stops',
    'gradient': [Color(0xFF1B5E20), Color(0xFF4CAF50)],
  },
  {
    'title':    'Blantyre → Liwonde',
    'duration': '2h drive',
    'stops':    '11 stops',
    'gradient': [Color(0xFF4E342E), Color(0xFF8D6E63)],
  },
  {
    'title':    'Zomba → Monkey Bay',
    'duration': '3h drive',
    'stops':    '8 stops',
    'gradient': [Color(0xFF0D47A1), Color(0xFF42A5F5)],
  },
];

const _filterLabels = ['All', '🐘 Wildlife', '🛒 Markets', '🏞️ Nature', '💧 Water'];

const _pois = [
  {
    'emoji': '🐘',
    'bg':    Color(0xFFE8F5E9),
    'title': 'Liwonde National Park',
    'desc':  'Hippos, elephants & river safaris',
    'badge': 'Open',
    'badgeBg': Color(0xFFE8F5E9),
    'badgeColor': Color(0xFF2E7D32),
  },
  {
    'emoji': '🥭',
    'bg':    Color(0xFFFFF3E0),
    'title': 'Mango Market – Salima',
    'desc':  'Seasonal fruit & local produce',
    'badge': '2.4 km',
    'badgeBg': Color(0xFFFFF3E0),
    'badgeColor': Color(0xFFE65100),
  },
  {
    'emoji': '🌿',
    'bg':    Color(0xFFF1F8E9),
    'title': 'Lengwe Forest Reserve',
    'desc':  'Nyala antelope & miombo forest',
    'badge': '14 km',
    'badgeBg': Color(0xFFF1F8E9),
    'badgeColor': Color(0xFF33691E),
  },
  {
    'emoji': '💧',
    'bg':    Color(0xFFE3F2FD),
    'title': 'Shire River Crossing',
    'desc':  'Crocodile & hippo sightings',
    'badge': '31 km',
    'badgeBg': Color(0xFFE3F2FD),
    'badgeColor': Color(0xFF1565C0),
  },
];

// ══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _activeFilter = 0;

  late final AnimationController _animCtrl;
  late final Animation<double>    _fadeAnim;
  late final Animation<Offset>    _slideAnim;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Mwadzuka bwanji 👋';  // Good morning
    if (h < 17) return 'Mwaswera bwanji 👋';  // Good afternoon
    return 'Mwangonanji 👋';                   // Good evening
  }

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 550),
    );
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

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

                // ── Header ──────────────────────────────────
                SliverToBoxAdapter(child: _buildHeader()),

                // ── Body ────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([

                      // Popular Journeys
                      _sectionHeader('Popular Journeys', onTap: () {}),
                      const SizedBox(height: 12),
                      _journeyCards(),

                      const SizedBox(height: 24),

                      // Nearby Discoveries
                      _sectionHeader('Nearby Discoveries',
                          trailing: 'View map →', onTap: () {}),
                      const SizedBox(height: 12),

                      // Filter chips
                      _filterChips(),
                      const SizedBox(height: 14),

                      // POI list
                      ..._pois.asMap().entries.map((e) =>
                          _PoiCard(poi: e.value, delay: e.key * 60)),

                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    // Get display name from Firebase Auth
    final user = AuthService().currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Traveller';

    return Container(
      padding: EdgeInsets.only(
        top: topPad + 12,
        left: 16, right: 16, bottom: 20,
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
          // Decorative glow
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _clay.withOpacity(0.15),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  // Logo
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: _white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _white.withOpacity(0.25)),
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
                      color: _white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Notification bell
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: _white.withOpacity(0.85),
                      size: 22,
                    ),
                  ),
                  // Avatar
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _clay,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _white.withOpacity(0.3), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty
                              ? name[0].toUpperCase()
                              : 'M',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Greeting
              Text(
                _greeting,
                style: TextStyle(
                  fontSize: 13,
                  color: _white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Where to today, $name?',
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _white,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 16),

              // Search bar
              GestureDetector(
                onTap: () {}, // open search screen
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: _white.withOpacity(0.6), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Search destinations...',
                        style: TextStyle(
                          fontSize: 14,
                          color: _white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section header ────────────────────────────────────────
  Widget _sectionHeader(String title,
      {String trailing = 'See all →', VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C1A0E),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            trailing,
            style: const TextStyle(
              fontSize: 13,
              color: _clay,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ── Journey cards (horizontal scroll) ────────────────────
  Widget _journeyCards() {
    return SizedBox(
      height: 115,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _journeys.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final j = _journeys[i];
          return _JourneyCard(journey: j);
        },
      ),
    );
  }

  // ── Filter chips ──────────────────────────────────────────
  Widget _filterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = i == _activeFilter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? _clay : _white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? _clay : _clay.withOpacity(0.2),
                ),
                boxShadow: active
                    ? [
                  BoxShadow(
                    color: _clay.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : null,
              ),
              child: Text(
                _filterLabels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active ? _white : _textMid,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  JOURNEY CARD
// ─────────────────────────────────────────────
class _JourneyCard extends StatelessWidget {
  final Map<String, dynamic> journey;
  const _JourneyCard({required this.journey});

  @override
  Widget build(BuildContext context) {
    final colors = journey['gradient'] as List<Color>;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 165,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    journey['title'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _miniTag(journey['duration'] as String),
                      const SizedBox(width: 5),
                      _miniTag(journey['stops'] as String),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: _white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  POI CARD
// ─────────────────────────────────────────────
class _PoiCard extends StatelessWidget {
  final Map<String, dynamic> poi;
  final int delay;
  const _PoiCard({required this.poi, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: _white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          splashColor: _clay.withOpacity(0.06),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(16),
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
                // Icon
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: poi['bg'] as Color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      poi['emoji'] as String,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poi['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C1A0E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        poi['desc'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: poi['badgeBg'] as Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    poi['badge'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: poi['badgeColor'] as Color,
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
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/journey_screen.dart';
import 'screens/market_screen.dart';
import 'screens/profile_screen.dart';

void main() => runApp( const MbuyaApp());

class MbuyaApp extends StatelessWidget {
  const MbuyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mbuya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF7F0),
        fontFamily: 'DMsans'
      ),
      home: const MbuyaRoot(),
    );
  }
}

class MbuyaRoot extends StatefulWidget{
  const MbuyaRoot({super.key});

  @override
  State<MbuyaRoot> createState() => _MbuyaRootState();
}

class _MbuyaRootState extends State<MbuyaRoot> {
  int _currentIndex = 0;

  // four screens

  final List<Widget> _screens = const [
    HomeScreen(),
    JourneyScreen(),
    MarketScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Swap body based on current tab
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: _MbuyaNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _MbuyaNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MbuyaNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const clay = Color(0xFFC47B3E);
    const clayDark = Color(0xFF9B5E2A);
    const softText = Color(0xFFA88060);
    const white = Colors.white;

    final items = [
      (icon: Icons.home_rounded,        label: 'Home'),
      (icon: Icons.map_rounded,          label: 'Journey'),
      (icon: Icons.storefront_rounded,   label: 'Market'),
      (icon: Icons.person_rounded,       label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C1A0E).withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: clay.withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70, // Increased height from 60 to 70 to fix overflow
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated icon with indicator dot
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? clay.withOpacity(0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item.icon,
                                size: 22,
                                color: isActive ? clay : softText,
                              ),
                            ),
                            // Active indicator dot above icon
                            if (isActive)
                              Positioned(
                                top: -2,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: clayDark,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2), // Reduced from 3 to 2
                        // Label
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive ? clay : softText,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
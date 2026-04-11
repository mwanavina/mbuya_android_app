// lib/widgets/mbuya_app_bar.dart
import 'package:flutter/material.dart';

class MbuyaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final bool showBack;

  const MbuyaAppBar({
    super.key,
    this.actions,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3D2010),
      elevation: 0,
      automaticallyImplyLeading: showBack,

      // ── Logo + Name on the left ──
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon box
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                '🍃',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // App name
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Mbuya',
                  style: TextStyle(
                    fontFamily: 'Georgia', // swap for Playfair if added
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Optional right-side action buttons
      actions: actions ??
          [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white70,
                size: 22,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
          ],

      // Bottom border line
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFC47B3E).withOpacity(0.25),
        ),
      ),
    );
  }

  // Flutter needs this to know how tall the AppBar is
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
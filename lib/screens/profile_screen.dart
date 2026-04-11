// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../widgets/mbuya_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Profile screen has no notification bell — pass custom actions
      appBar: const MbuyaAppBar(
        actions: [],
      ),
      body: const Center(child: Text('Profile')),
    );
  }
}
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/mbuya_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MbuyaAppBar(),
      body: const Center(child: Text('Home')),
    );
  }
}
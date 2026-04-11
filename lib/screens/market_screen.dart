// lib/screens/market_screen.dart
import 'package:flutter/material.dart';
import '../widgets/mbuya_app_bar.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MbuyaAppBar(),
      body: const Center(child: Text('Market')),
    );
  }
}
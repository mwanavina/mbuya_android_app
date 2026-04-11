// lib/screens/journey_screen.dart
import 'package:flutter/material.dart';
import '../widgets/mbuya_app_bar.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MbuyaAppBar(),
      body: const Center(child: Text('Journey')),
    );
  }
}
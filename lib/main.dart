import 'package:flutter/material.dart';
import 'package:mbuya_android_app/home.dart';
import 'package:mbuya_android_app/loading.dart';

void main() {
  runApp( MaterialApp(
    initialRoute: '/home',
    routes: {
      // '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/loading': (context) => Loading(),
    }
  ));
}
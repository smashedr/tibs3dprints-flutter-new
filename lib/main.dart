import 'package:flutter/material.dart';

import 'home_app.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tibs3DPrints',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const BottomNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

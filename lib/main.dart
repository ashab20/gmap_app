import 'package:flutter/material.dart';
import 'package:gmap_app/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Time Google Map',
      home: HomeScreen(),
    );
  }
}


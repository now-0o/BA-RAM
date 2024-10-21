import 'package:baram/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/load_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoadScreen(),
    );
  }
}

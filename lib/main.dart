import 'package:flutter/material.dart';
import '../page/splash_screen.dart';


void main() {
  runApp(const BubbleWashApp());
}

// Top-level stateful app to allow theme switching at runtime
class BubbleWashApp extends StatefulWidget {
  const BubbleWashApp({super.key});

  @override
  State<BubbleWashApp> createState() => _BubbleWashAppState();
}

class _BubbleWashAppState extends State<BubbleWashApp> {
  // themeMode stored in-memory for the session
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleWash',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA7C7E7), // pastel blue seed
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF90CAF9),
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // Start with SplashScreen
      home: SplashScreen(
        onFinish: () {
          // opsional: bisa dipakai kalau splash screen butuh callback
        },
        toggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
    );
  }
}

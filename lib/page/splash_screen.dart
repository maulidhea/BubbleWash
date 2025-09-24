import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const SplashScreen({
    super.key,
    required this.onFinish,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = Tween<double>(begin: 0.8, end: 1.02)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_anim);
    _anim.forward();

    // auto navigate after 1.6s
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) => LoginLauncher(
              toggleTheme: widget.toggleTheme,
              themeMode: widget.themeMode,
            ),
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 68,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF3A8DDE), Color(0xFFF8BBD0)],
                  ).createShader(bounds),
                  child: const Text(
                    'BubbleWash',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Cepat • Bersih • Ramah Lingkungan'),
                // >>> Tambahkan nama di sini <<<
                const SizedBox(height: 4),
                const Text(
                  'hanna maulidhea_091',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Launcher page to supply theme toggle to LoginPage easily
class LoginLauncher extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;
  const LoginLauncher({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return LoginPage(toggleTheme: toggleTheme, themeMode: themeMode);
  }
}

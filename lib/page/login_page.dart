/// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'forgotpassword_page.dart';
import 'register_page.dart';
import 'home_page.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? toggleTheme;
  final ThemeMode? themeMode;

  const LoginPage({super.key, this.toggleTheme, this.themeMode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _obscure = true;
  bool _remember = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _obscure = !_obscure);

  /// =========================================
  /// SUBMIT LOGIN → buat object MemberUser
  /// =========================================
  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));

      // Buat instance model OOP
      final user = MemberUser(
        _emailC.text.trim(),
        'Pengguna BubbleWash', // contoh nama
        '2023-01-01', // contoh tanggal member sejak
      );

      // Arahkan ke HomePage dengan object User
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => HomePage(user: user, email: ''),
          transitionsBuilder: (_, anim, __, child) {
            final t = CurvedAnimation(parent: anim, curve: Curves.easeOut);
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.12),
                end: Offset.zero,
              ).animate(t),
              child: FadeTransition(opacity: t, child: child),
            );
          },
        ),
      );
    }
  }

  void goToRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  void goToForgot() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (widget.toggleTheme != null && widget.themeMode != null)
            IconButton(
              tooltip: widget.themeMode == ThemeMode.light
                  ? 'Dark mode'
                  : 'Light mode',
              icon: Icon(
                widget.themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.sunny,
              ),
              onPressed: widget.toggleTheme,
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 72,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF3A8DDE), Color(0xFFF8BBD0)],
                        ).createShader(bounds),
                        child: const Text(
                          "BubbleWash",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailC,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'nama@gmail.com',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                if (value.isEmpty) return 'Email wajib diisi';
                                if (!RegExp(r'^.+@.+\..+$').hasMatch(value)) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passC,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: _toggleObscure,
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  tooltip: _obscure
                                      ? 'Tampilkan password'
                                      : 'Sembunyikan password',
                                ),
                              ),
                              validator: (v) {
                                final value = v ?? '';
                                if (value.isEmpty)
                                  return 'Password wajib diisi';
                                if (value.length < 6) {
                                  return 'Minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v ?? false),
                                ),
                                const Text('Ingat saya'),
                                const Spacer(),
                                TextButton(
                                  onPressed: goToForgot,
                                  child: const Text('Lupa password?'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.login),
                          label: const Text('Login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A8DDE),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                SignInButton(Buttons.google, onPressed: () {});
                              },
                              icon: const Icon(Icons.g_mobiledata),
                              label: const Text('Masuk dengan Google'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Belum punya akun? "),
                            TextButton(
                              onPressed: goToRegister,
                              child: const Text('Daftar'),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SignInButton(
                            Buttons.facebook,
                            mini: true,
                            onPressed: () {},
                          ),
                          SizedBox(width: 10),
                          SignInButton(
                            Buttons.gitHub,
                            mini: true,
                            onPressed: () {},
                          ),
                          SizedBox(width: 10),
                          SignInButton(
                            Buttons.twitter,
                            mini: true,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

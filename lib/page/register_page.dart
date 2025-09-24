import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  void _toggle() => setState(() => _obscure = !_obscure);

  void _register() {
    if (_form.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil (demo). Silakan login.'),
        ),
      );
      Navigator.of(context).pop(); // kembali ke halaman login
    }
  }

  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^.+@.+\..+$').hasMatch(s)) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return 'Password wajib diisi';
    if (s.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pastelBlue = const Color(0xFFA7C7E7);
    final pastelPink = Colors.pink.shade100;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Akun',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: pastelBlue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Buat Akun BubbleWash",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // === Field Nama ===
                      TextFormField(
                        controller: _nameC,
                        decoration: InputDecoration(
                          labelText: 'Nama lengkap',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: pastelPink.withOpacity(.2),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Nama wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // === Field Email ===
                      TextFormField(
                        controller: _emailC,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: pastelPink.withOpacity(.2),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 12),

                      // === Field HP ===
                      TextFormField(
                        controller: _phoneC,
                        decoration: InputDecoration(
                          labelText: 'No. HP (opsional)',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: pastelPink.withOpacity(.2),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      // === Password ===
                      TextFormField(
                        controller: _passC,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: pastelPink.withOpacity(.2),
                          suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: Icon(_obscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        obscureText: _obscure,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 12),

                      // === Konfirmasi Password ===
                      TextFormField(
                        controller: _confirmC,
                        decoration: InputDecoration(
                          labelText: 'Konfirmasi Password',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: pastelPink.withOpacity(.2),
                        ),
                        obscureText: _obscure,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Konfirmasi password wajib';
                          }
                          if (v != _passC.text) return 'Password tidak cocok';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A8DDE),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Daftar Sekarang',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
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

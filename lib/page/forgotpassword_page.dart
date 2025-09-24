import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      // ✅ Dummy notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF7DA2C4), // biru pastel
          content: Text(
            'Link reset password telah dikirim ke ${_emailC.text.trim()} (dummy)',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      );

      // ✅ Kembali ke halaman login setelah 2 detik
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC), // putih kebiruan
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFA7C7E7), // biru pastel
        title: Text(
          "Reset Password",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // ✅ Ilustrasi icon kunci
            Icon(
              Icons.lock_reset,
              size: 100,
              color: Colors.pink.shade300.withOpacity(0.8),
            ),
            const SizedBox(height: 20),

            Text(
              "Lupa Password?",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3A8DDE), // biru cerah
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Masukkan email akun BubbleWash Anda.\nKami akan mengirim link reset password (dummy).",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 35),

            // ===== Form Email =====
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "nama@gmail.com",
                  labelStyle: GoogleFonts.poppins(),
                  hintStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
            ),
            const SizedBox(height: 25),

            // ===== Tombol Kirim =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DA2C4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Kirim Link Reset",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ===== Tombol kembali ke login =====
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text(
                "Kembali ke Halaman Login",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF3A8DDE),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

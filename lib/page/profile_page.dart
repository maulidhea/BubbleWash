import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';            // halaman login
import '../models/user.dart';         // ✅ AppUser & MemberUser

// ======================================================
//  PROFILE PAGE + akses ke SettingsPage
// ======================================================
class ProfilePage extends StatelessWidget {
  final String email;
  final String telepon;
  final String alamat;
  final String memberSejak;
  final String namaPengguna; // ✅ nama asli pengguna

  const ProfilePage({
    super.key,
    required this.email,
    required this.namaPengguna,
    this.telepon = '',
    this.alamat = '',
    this.memberSejak = '',
  });

  @override
  Widget build(BuildContext context) {
    // Objek OOP MemberUser
    final member = MemberUser(
      email,
      namaPengguna,
      memberSejak,
    );

    member.login(); // contoh polymorphism

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA7C7E7), Color(0xFFF8C8DC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: "Pengaturan",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    "Konfirmasi Logout",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    "Apakah Anda yakin ingin keluar?",
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        "Batal",
                        style: GoogleFonts.poppins(color: Colors.black54),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      // ===== Body =====
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFBFF), Color(0xFFF8C8DC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),

            // ===== Foto profil =====
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.pink.shade200,
              child: const Icon(Icons.person, size: 65, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // ===== Nama Pengguna (asli) =====
            Center(
              child: Text(
                member.name, // ✅ tampilkan nama dari MemberUser
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
            // ===== Email pengguna =====
            Center(
              child: Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== Info lainnya =====
            _infoTile(Icons.phone, "Telepon", telepon),
            _infoTile(Icons.home, "Alamat", alamat),
            _infoTile(Icons.calendar_today, "Member Sejak", memberSejak),
          ],
        ),
      ),
    );
  }

  /// Widget helper untuk setiap baris informasi
  Widget _infoTile(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      shadowColor: Colors.pink.shade100.withOpacity(0.4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.blueGrey.shade700,
          ),
        ),
        subtitle: Text(
          value.isEmpty ? '-' : value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.blueGrey.shade900,
          ),
        ),
      ),
    );
  }
}

// ======================================================
//  SETTINGS PAGE (tetap sama)
// ======================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF7DA2C4),
        title: Text(
          "Pengaturan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),

            _switchCard(
              icon: Icons.dark_mode,
              title: "Mode Gelap",
              subtitle: "Aktifkan / nonaktifkan tema gelap",
              value: darkMode,
              onChanged: (val) {
                setState(() => darkMode = val);
                _snack(context, "Mode Gelap ${val ? 'Aktif' : 'Nonaktif'}");
              },
            ),

            const SizedBox(height: 12),

            _switchCard(
              icon: Icons.notifications,
              title: "Notifikasi",
              subtitle: "Terima update status pesanan",
              value: notifications,
              onChanged: (val) {
                setState(() => notifications = val);
                _snack(context, "Notifikasi ${val ? 'Aktif' : 'Nonaktif'}");
              },
            ),

            const SizedBox(height: 12),

            _listCard(
              icon: Icons.info,
              title: "Tentang Aplikasi",
              subtitle: "BubbleWash v1.0.0",
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "BubbleWash",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2025 BubbleWash Team",
                );
              },
            ),

            const SizedBox(height: 12),

            _listCard(
              icon: Icons.help,
              title: "Bantuan & FAQ",
              onTap: () => _snack(context, "Buka halaman Bantuan (demo)"),
            ),

            const SizedBox(height: 12),

            _listCard(
              icon: Icons.logout,
              title: "Logout",
              iconColor: Colors.redAccent,
              titleColor: Colors.redAccent,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: SwitchListTile(
        title: Text(title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle:
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 13)),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: const Color(0xFF3A8DDE)),
      ),
    );
  }

  Widget _listCard({
    required IconData icon,
    required String title,
    String subtitle = '',
    Color iconColor = const Color(0xFF3A8DDE),
    Color titleColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: titleColor,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle.isEmpty
            ? null
            : Text(subtitle, style: GoogleFonts.poppins(fontSize: 13)),
        onTap: onTap,
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: GoogleFonts.poppins())),
    );
  }
}

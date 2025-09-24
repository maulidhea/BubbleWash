import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final titleStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.black87,
    );
    final subtitleStyle = GoogleFonts.poppins(fontSize: 13);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF7DA2C4), // biru pastel
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
            colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)], // biru ke pink pastel
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),

            // === Mode Gelap ===
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: SwitchListTile(
                title: Text("Mode Gelap", style: titleStyle),
                subtitle: Text("Aktifkan / nonaktifkan tema gelap",
                    style: subtitleStyle),
                value: darkMode,
                onChanged: (val) {
                  setState(() => darkMode = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Mode Gelap ${val ? 'Aktif' : 'Nonaktif'}",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                },
                secondary: const Icon(Icons.dark_mode, color: Color(0xFF3A8DDE)),
              ),
            ),
            const SizedBox(height: 12),

            // === Notifikasi ===
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: SwitchListTile(
                title: Text("Notifikasi", style: titleStyle),
                subtitle: Text("Terima update status pesanan",
                    style: subtitleStyle),
                value: notifications,
                onChanged: (val) {
                  setState(() => notifications = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Notifikasi ${val ? 'Aktif' : 'Nonaktif'}",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                },
                secondary:
                    const Icon(Icons.notifications, color: Color(0xFF3A8DDE)),
              ),
            ),
            const SizedBox(height: 12),

            // === Tentang Aplikasi ===
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.info, color: Color(0xFF3A8DDE)),
                title: Text("Tentang Aplikasi", style: titleStyle),
                subtitle: Text("BubbleWash v1.0.0", style: subtitleStyle),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "BubbleWash",
                    applicationVersion: "1.0.0",
                    applicationLegalese: "© 2025 BubbleWash Team",
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // === Bantuan & FAQ ===
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.help, color: Color(0xFF3A8DDE)),
                title: Text("Bantuan & FAQ", style: titleStyle),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Buka halaman Bantuan (demo)",
                          style: GoogleFonts.poppins()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // === 🚪 Logout ===
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===== Dummy login page, ganti dengan halaman login asli Anda =====
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(
            'Halaman Login',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}

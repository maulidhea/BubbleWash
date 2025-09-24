import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/laundry_order.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailPage extends StatelessWidget {
  final LaundryOrder order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    const pastelBackground = Color(0xFFFDFBFF);

    return Scaffold(
      backgroundColor: pastelBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detail Pesanan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90CAF9), Color(0xFFF48FB1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 Card informasi utama
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: const Color(0xFF90CAF9).withOpacity(0.2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3F2FD), Color(0xFFFCE4EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.confirmation_num, "ID Pesanan", order.id),
                    const Divider(thickness: 1, color: Color(0xFFB3E5FC)),
                    _buildInfoRow(Icons.local_shipping, "Status", order.status),
                    const Divider(thickness: 1, color: Color(0xFFB3E5FC)),
                    _buildInfoRow(Icons.timer, "Estimasi", order.estimasi),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🫧 Daftar item laundry
            Text(
              "🧺 Daftar Item Laundry",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5C6BC0)),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              shadowColor: Colors.pink.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: order.items
                      .map(
                        (item) => Chip(
                          avatar: const Icon(Icons.local_laundry_service,
                              color: Color(0xFF64B5F6), size: 18),
                          backgroundColor: const Color(0xFFF8BBD0), // pink pastel
                          label: Text(
                            '${item.name} (${item.qty} x Rp${item.price})',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 💸 Total Harga
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFFF48FB1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  "💰 Total: Rp${order.total}",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 🛒 Tombol Pesan Sekarang
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color(0xFFF48FB1),
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: const Color(0xFFF48FB1).withOpacity(0.4),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("✅ Pesanan berhasil dibuat!")),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                label: Text(
                  "Pesan Sekarang",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper row info
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF64B5F6)),
        const SizedBox(width: 12),
        Text(
          "$label:",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5C6BC0),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF455A64),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

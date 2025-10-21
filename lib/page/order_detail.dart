import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===== MODEL =====
import '../models/order_base.dart';  // class BaseOrder 
import '../models/laundry_order.dart';  // class LaundryOrder extends BaseOrder
import '../models/order_item.dart';   // class OrderItem

/// ===============================================================
/// DETAIL PESANAN
/// ===============================================================
class OrderDetailPage extends StatelessWidget {
  final LaundryOrder order;
  const OrderDetailPage({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "selesai":
        return Colors.green;
      case "proses":
        return Colors.orange;
      case "batal":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF90CAF9), Color(0xFFF8BBD0)], // biru → pink
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🧾 Detail Pesanan",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // ===== CARD INFORMASI =====
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: Colors.pink.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.receipt_long, "ID Pesanan", order.id),
                        const Divider(),
                        _buildInfoRow(Icons.access_time, "Estimasi", order.estimasi),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Text(
                              "Status: ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Chip(
                              label: Text(
                                order.status,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _getStatusColor(order.status),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ===== DAFTAR ITEM =====
                Text(
                  "🧺 Daftar Item",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),

                ...order.items.map((OrderItem item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                    shadowColor: Colors.blueAccent.withOpacity(0.2),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFBBDEFB),
                        child: const Icon(Icons.local_laundry_service,
                            color: Color(0xFF1976D2)),
                      ),
                      title: Text(
                        item.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(
                        "Qty: ${item.qty} | Harga: Rp${item.price}",
                        style: GoogleFonts.poppins(
                            color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 24),

                // ===== RINGKASAN =====
                Text(
                  "💰 Ringkasan Pembayaran",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),

                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: Colors.pinkAccent.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildSummaryRow("Subtotal", order.subtotal),
                        _buildSummaryRow("Diskon", -order.discount),
                        const Divider(),
                        _buildSummaryRow("Total", order.total, bold: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ===== TOMBOL PESAN =====
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: const Color(0xFFF48FB1),
                      foregroundColor: Colors.white,
                      elevation: 6,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pesanan berhasil dibuat!"),
                          backgroundColor: Color(0xFF64B5F6),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Text(
                      "Pesan Sekarang",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15)),
          Text(
            "Rp$value",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: bold ? Colors.pinkAccent : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

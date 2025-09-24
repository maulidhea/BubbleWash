import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===== MODEL =====
import '../models/global_orders.dart';
import '../models/laundry_order.dart';
import '../models/user.dart';          // ✅ tambahkan

// ===== PAGE =====
import 'order_detail_page.dart';
import 'home_page.dart';

class OrdersPage extends StatelessWidget {
  final String email;
  const OrdersPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<LaundryOrder> orders =
        List<LaundryOrder>.from(globalOrders.reversed);

    // ✅ Buat instance user sementara / ambil dari session
    final AppUser currentUser = GuestUser(
      email: email,
      name: "Guest",   // ganti sesuai data user jika ada
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Pesanan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            tooltip: 'Kembali ke Home',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    email: email,
                    user: currentUser,   // ✅ penting
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: orders.isEmpty
              ? Center(
                  child: Text(
                    "Belum ada pesanan",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailPage(order: order),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade200,
                                Colors.pink.shade100,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 24,
                                child: Text(
                                  "${index + 1}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pesanan #${order.id}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${order.status} • Estimasi ${order.estimasi}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

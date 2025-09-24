import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ====== Import halaman lain ======
import 'checkout_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

// ====== Import model user (supaya bisa kirim AppUser ke HomePage) ======
import '../models/user.dart';

/// ===========================================================
/// CART PAGE - Menampilkan item keranjang + hapus + checkout
/// ===========================================================
class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    // Salin data awal keranjang agar bisa dimodifikasi
    _items = List<Map<String, dynamic>>.from(widget.cartItems);
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total harga
    final total = _items.fold<int>(0, (sum, item) {
      final price = item["price"];
      return sum + (price is int ? price : int.tryParse(price.toString()) ?? 0);
    });

    const pastelBlue = Color(0xFF7DA2C4);
    const pastelPink = Color(0xFFF7C6D9);
    const pastelWhite = Color(0xFFFDFDFD);

    return Scaffold(
      backgroundColor: pastelWhite,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: pastelBlue,
        title: Text(
          "Keranjang",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Ke Beranda",
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // ✅ HomePage butuh email & user: berikan default guest
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    email: "guest@example.com",
                    user: GuestUser(), // -> class GuestUser ada di models/user.dart
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Profil",
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(
                    email: "guest@example.com",
                    telepon: "08123456789",
                    alamat: "Jl. Contoh No. 123",
                    memberSejak: "2023", 
                    namaPengguna: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ===== BODY =====
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.cartShopping,
                      size: 70, color: Colors.grey),
                  const SizedBox(height: 14),
                  Text(
                    "Keranjang masih kosong 😅",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // ===== List item keranjang =====
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              pastelBlue.withOpacity(0.25),
                              pastelPink.withOpacity(0.35)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: pastelPink.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          leading: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: FaIcon(
                              FontAwesomeIcons.soap,
                              color: Color(0xFF7DA2C4),
                              size: 26,
                            ),
                          ),
                          title: Text(
                            item["name"].toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: const Color(0xFF5A6C8A),
                            ),
                          ),
                          subtitle: Text(
                            "Rp ${item["price"]} / kg",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: const Color(0xFF9AA5B1),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _items.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ===== Total & Tombol Checkout =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: pastelBlue.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5A6C8A),
                            ),
                          ),
                          Text(
                            "Rp $total",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: pastelBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(cartItems: _items),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pastelBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                        label: Text(
                          "Lanjut ke Checkout",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

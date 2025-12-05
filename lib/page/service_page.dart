import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/global_cart.dart';      // ✅ import keranjang global
import 'checkout_page.dart';

/// =============================
/// MODEL : ServiceItem
/// =============================
class ServiceItem {
  final String title;
  final String details;
  final int cost;
  final String duration;
  final IconData icon;

  ServiceItem({
    required this.title,
    required this.details,
    required this.cost,
    required this.duration,
    required this.icon,
  });

  String get costLabel => 'Rp$cost';
}

/// =============================
/// PAGE : ServicePage
/// =============================
class ServicePage extends StatefulWidget {
  const ServicePage({super.key, required this.email});
  final String email;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final items = <ServiceItem>[
    ServiceItem(
        title: 'Cuci Kiloan',
        details: 'Cuci pakaian harian dengan deterjen premium.',
        cost: 7000,
        duration: '2 hari',
        icon: Icons.local_laundry_service),
    ServiceItem(
        title: 'Setrika Saja',
        details: 'Setrika uap untuk hasil rapi dan wangi.',
        cost: 5000,
        duration: '1 hari',
        icon: Icons.iron),
    ServiceItem(
        title: 'Dry Cleaning',
        details: 'Perawatan khusus pakaian berbahan halus.',
        cost: 25000,
        duration: '3 hari',
        icon: Icons.dry_cleaning),
    ServiceItem(
        title: 'Cuci Selimut',
        details: 'Layanan cuci selimut tebal dan bed cover.',
        cost: 30000,
        duration: '3 hari',
        icon: Icons.bed),
    ServiceItem(
        title: 'Cuci Sepatu',
        details: 'Perawatan dan pembersihan sepatu segala jenis.',
        cost: 20000,
        duration: '2 hari',
        icon: Icons.directions_run),
    ServiceItem(
        title: 'Laundry Ekspres',
        details: 'Layanan kilat selesai dalam 6 jam.',
        cost: 15000,
        duration: '6 jam',
        icon: Icons.flash_on),
  ];

  /// ✅ Tambah item ke keranjang global
  void _addToCart(ServiceItem item) {
    setState(() {
      globalCart.addItem(item.title, item.cost);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ ${item.title} ditambahkan ke keranjang')),
    );
  }

  /// ✅ Pindah ke halaman checkout
  void _goToCheckout() {
    if (globalCart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(cartItems: globalCart.items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pastelBlue = Color(0xFF7DA2C4);
    final pastelPink = Colors.pink.shade100;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: pastelBlue,
        centerTitle: true,
        title: Text(
          'Pilihan Layanan Laundry',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Lihat Checkout',
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _goToCheckout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailPage(
                          item: item,
                          onAdd: () => _addToCart(item),
                        ),
                      ),
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: pastelPink.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(item.icon,
                                  color: const Color(0xFF3A8DDE), size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title,
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87)),
                                  const SizedBox(height: 4),
                                  Text(item.details,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.grey[700])),
                                  const SizedBox(height: 8),
                                  Text('Harga: ${item.costLabel}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.pink[700])),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: pastelBlue,
        onPressed: _goToCheckout,
        icon: const Icon(Icons.shopping_cart),
        label: Text(
          // ✅ jumlah total berdasarkan qty
          'Checkout (${globalCart.totalQty})',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }
}

/// =============================
/// PAGE : ServiceDetailPage
/// =============================
class ServiceDetailPage extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onAdd;
  const ServiceDetailPage({super.key, required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    const pastelBlue = Color(0xFF7DA2C4);
    const pastelPink = Color(0xFFF8BBD0);
    const pastelPurple = Color(0xFFD1C4E9);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          item.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [pastelBlue, pastelPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Icon Service dengan gradient bubble ---
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [pastelPink, pastelPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(30),
                child: Icon(item.icon, size: 90, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // --- Deskripsi ---
            Text(
              item.details,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // --- Harga & Estimasi jadi 2 card kecil ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile("Harga", item.costLabel, Colors.pink.shade400),
                _infoTile("Estimasi", item.duration, pastelBlue),
              ],
            ),

            const Spacer(),

            // --- Tombol CTA gradient ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                onPressed: () {
                  onAdd();
                  Navigator.pop(context);
                },
                label: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [pastelBlue, pastelPink],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Tambah ke Keranjang',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

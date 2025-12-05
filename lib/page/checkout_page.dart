import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===== MODEL =====
import '../models/laundry_order.dart';    // ✅ class LaundryOrder extends BaseOrder
import '../models/order_item.dart';       // ✅ class OrderItem
import '../models/global_cart.dart';      // ✅ instance globalCart
import '../models/global_orders.dart';    // ✅ list globalOrders
import '../page/promo_page.dart';         // ✅ class Promo

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CheckoutPage({super.key, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = "COD";
  String _selectedDelivery = "Antar Jemput";
  Promo? selectedPromo; // ✅ promo yang dipilih user

  void _removeItem(int index) {
    setState(() {
      if (widget.cartItems[index]['qty'] > 1) {
        widget.cartItems[index]['qty']--;
      } else {
        widget.cartItems.removeAt(index);
      }
    });
  }

  int get subtotal => widget.cartItems.fold<int>(
        0,
        (sum, e) => sum + (e['price'] as int) * (e['qty'] as int),
      );

  int get discount {
    if (selectedPromo == null) return 0;

    // jika badge promo pakai %
    if (selectedPromo!.badge.contains('%')) {
      final persen = int.tryParse(selectedPromo!.badge.replaceAll('%', '')) ?? 0;
      return subtotal * persen ~/ 100;
    }

    // jika badge promo FREE → contoh gratis ongkir Rp 10.000
    if (selectedPromo!.badge.toUpperCase() == "FREE") {
      return 10000;
    }
    return 0;
  }

  int get total => (subtotal - discount).clamp(0, 999999999);

  @override
  Widget build(BuildContext context) {
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
          'Checkout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'Keranjang kosong',
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // ===================
                  // DAFTAR ITEM KERANJANG
                  // ===================
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (_, i) {
                      final item = widget.cartItems[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: pastelPink,
                            child: const Icon(Icons.local_laundry_service,
                                color: Colors.white),
                          ),
                          title: Text(
                            '${item['name']}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                          ),
                          subtitle: Text(
                            'x${item['qty']}  •  Rp ${item['price'] * item['qty']}',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => _removeItem(i),
                          ),
                        ),
                      );
                    },
                  ),

                  // ===================
                  // PEMBAYARAN + PENGANTARAN + PROMO
                  // ===================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Metode Pembayaran",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                        RadioListTile<String>(
                          value: "COD",
                          groupValue: _selectedPayment,
                          onChanged: (v) => setState(() => _selectedPayment = v!),
                          title: const Text("Bayar di Tempat (COD)", style: TextStyle(color: Colors.black87)),
                        ),
                        RadioListTile<String>(
                          value: "Transfer Bank",
                          groupValue: _selectedPayment,
                          onChanged: (v) => setState(() => _selectedPayment = v!),
                          title: const Text("Transfer Bank", style: TextStyle(color: Colors.black87)),
                        ),
                        RadioListTile<String>(
                          value: "E-Wallet",
                          groupValue: _selectedPayment,
                          onChanged: (v) => setState(() => _selectedPayment = v!),
                          title: const Text("E-Wallet (OVO, Dana, Gopay)", style: TextStyle(color: Colors.black87)),
                        ),
                        const SizedBox(height: 10),
                        Text("Metode Pengantaran",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                        RadioListTile<String>(
                          value: "Antar Jemput",
                          groupValue: _selectedDelivery,
                          onChanged: (v) =>
                              setState(() => _selectedDelivery = v!),
                          title: const Text("Antar Jemput oleh BubbleWash", style: TextStyle(color: Colors.black87)),
                        ),
                        RadioListTile<String>(
                          value: "Ambil Sendiri",
                          groupValue: _selectedDelivery,
                          onChanged: (v) =>
                              setState(() => _selectedDelivery = v!),
                          title: const Text("Ambil Sendiri di Outlet", style: TextStyle(color: Colors.black87)),
                        ),
                        RadioListTile<String>(
                          value: "Kurir Online",
                          groupValue: _selectedDelivery,
                          onChanged: (v) =>
                              setState(() => _selectedDelivery = v!),
                          title: const Text("Kurir Online (Gojek/Grab)", style: TextStyle(color: Colors.black87)),
                        ),
                        const SizedBox(height: 16),

                        // ✅ Pilih Promo
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PromoPage()),
                            );
                            if (result != null && result is Promo) {
                              setState(() {
                                selectedPromo = result;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Promo dipilih: ${selectedPromo!.title}')),
                              );
                            }
                          },
                          icon: const Icon(Icons.local_offer),
                          label: Text(
                            selectedPromo == null
                                ? "Pilih Promo"
                                : "Promo: ${selectedPromo!.title}",
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pastelPink,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===================
                  // RINGKASAN TOTAL BAYAR
                  // ===================
                  Container(
                    decoration: BoxDecoration(
                      color: pastelBlue.withOpacity(0.1),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal',
                                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                            Text('Rp $subtotal',
                                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                          ],
                        ),
                        if (selectedPromo != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Diskon (${selectedPromo!.badge})',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.green[700])),
                              Text('- Rp $discount',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.green[700])),
                            ],
                          ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Bayar',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                            Text('Rp $total',
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: pastelBlue)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle_outline,
                              color: Colors.white),
                          label: Text(
                            'Proses Pesanan',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pastelBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            // ✅ Tambah pesanan ke globalOrders
                            globalOrders.add(
                              LaundryOrder(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                email: 'guest@example.com',
                                status: 'Diproses',
                                estimasi: '2 hari',
                                paymentMethod: _selectedPayment,
                                deliveryMethod: _selectedDelivery,
                                address: 'Jl. Belum Diisi',
                                subtotal: subtotal,
                                discount: discount,
                                total: total,
                                items: widget.cartItems
                                    .map(
                                      (e) => OrderItem(
                                        name: e['name'] as String,
                                        qty: e['qty'] as int,
                                        price: e['price'] as int,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );

                            // Bersihkan keranjang
                            globalCart.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '✅ Pesanan diproses!\nPembayaran: $_selectedPayment\nPengantaran: $_selectedDelivery\nTotal: Rp $total'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

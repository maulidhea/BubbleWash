import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/laundry_service.dart';

// ------------------------------
// 🎨 Warna Tema Pastel
// ------------------------------
const kBluePastel = Color(0xFFA7C7E7);
const kPinkPastel = Color(0xFFF8BBD0);
const kTextDark   = Color(0xFF4B5D73);
const kBgLight    = Color(0xFFFDFDFE);

// ------------------------------
// 🔧 THEME GLOBAL
// ------------------------------
final ThemeData pastelTheme = ThemeData(
  scaffoldBackgroundColor: kBgLight,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: kBluePastel,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);

// ------------------------------
// 📦 MODEL: Service + ExpressService
// ------------------------------
class Service {
  String _name;
  int _price;
  String _estimation;
  String _description;

  Service({
    required String name,
    required int price,
    required String estimation,
    required String description,
  })  : _name = name,
        _price = price,
        _estimation = estimation,
        _description = description;

  String get name => _name;
  set name(String v) {
    if (v.isEmpty) throw ArgumentError('Nama tidak boleh kosong');
    _name = v;
  }

  int get price => _price;
  set price(int v) {
    if (v < 0) throw ArgumentError('Harga negatif');
    _price = v;
  }

  String get estimation => _estimation;
  set estimation(String v) {
    if (v.isEmpty) throw ArgumentError('Estimasi kosong');
    _estimation = v;
  }

  String get description => _description;
  set description(String v) {
    if (v.isEmpty) throw ArgumentError('Deskripsi kosong');
    _description = v;
  }

  String get formattedPrice => "Rp $_price";
  String serviceSummary() => "$_name - $_estimation - $formattedPrice";
}

class ExpressService extends Service {
  int _expressFee;
  ExpressService({
    required String name,
    required int price,
    required String estimation,
    required String description,
    required int expressFee,
  })  : _expressFee = expressFee,
        super(
          name: name,
          price: price,
          estimation: estimation,
          description: description,
        );

  int get expressFee => _expressFee;
  set expressFee(int v) {
    if (v < 0) throw ArgumentError('Fee negatif');
    _expressFee = v;
  }

  @override
  String get formattedPrice => "Rp ${price + _expressFee}";
}

// ---------------------------------------------------
// 🛒 MODEL: CartItem
// ---------------------------------------------------
class CartItem {
  final String name;
  final int price;
  int qty;

  CartItem({required this.name, required this.price, this.qty = 1});

  int get total => price * qty;
}

// ---------------------------------------------------
// 🛒 PAGE: CheckoutPage
// ---------------------------------------------------
class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  const CheckoutPage({super.key, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int get total => widget.cartItems.fold(0, (sum, item) => sum + item.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildGradientAppBar("Keranjang & Checkout"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, i) {
                final item = widget.cartItems[i];
                return Card(
                  color: kBluePastel.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(item.name,
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: kTextDark)),
                    subtitle: Text('Rp${item.price}',
                        style: GoogleFonts.poppins(color: kTextDark)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: kTextDark),
                          onPressed: () {
                            setState(() {
                              if (item.qty > 1) item.qty--;
                            });
                          },
                        ),
                        Text('${item.qty}',
                            style: GoogleFonts.poppins(color: kTextDark)),
                        IconButton(
                          icon: const Icon(Icons.add, color: kTextDark),
                          onPressed: () {
                            setState(() => item.qty++);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total: Rp$total',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kTextDark)),
                const SizedBox(height: 12),
                _buildGradientButton(
                  text: "Konfirmasi Pesanan",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesanan dikonfirmasi!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// 📄 PAGE: ServiceDetailPage
// ---------------------------------------------------
class ServiceDetailPage extends StatelessWidget {
  final LaundryService service;
  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildGradientAppBar(service.name),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.clock,
                    color: kBluePastel, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Estimasi: ${service.duration}",
                  style: GoogleFonts.poppins(fontSize: 17, color: kTextDark),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.moneyBillWave,
                    color: kPinkPastel, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Harga: Rp${service.price}",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextDark),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Deskripsi",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: kTextDark),
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: GoogleFonts.poppins(
                  fontSize: 16, color: Colors.grey[800]),
            ),
            const Spacer(),
            _buildGradientButton(
              text: "Pesan Sekarang",
              icon: Icons.shopping_cart,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(
                      cartItems: [
                        CartItem(
                          name: service.name,
                          price: service.price,
                          qty: 1,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// 🛠️ Widget Helper: Gradient AppBar & Button
// ---------------------------------------------------
PreferredSizeWidget _buildGradientAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kBluePastel, kPinkPastel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  );
}

Widget _buildGradientButton({
  required String text,
  IconData? icon,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [kBluePastel, kPinkPastel],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox(),
      label: Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ),
  );
}

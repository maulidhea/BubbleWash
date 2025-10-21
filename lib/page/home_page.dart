import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

// ===== Model =====
import '../models/user.dart';
import '../models/laundry_service.dart';
import '../models/global_cart.dart';

// ===== Page lain =====
import '../page/orders_page.dart';
import '../page/profile_page.dart';
import '../page/service_page.dart' hide ServiceDetailPage;
import '../page/checkout_page.dart';
import '../page/service_detail.dart' hide CheckoutPage;
import '../page/promo_page.dart';

class HomePage extends StatefulWidget {
  final String email;
  final AppUser user;
  const HomePage({Key? key, required this.email, required this.user})
    : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedChip = 0;

  final pastelBlue = const Color(0xFFA7C7E7);
  final pastelPink = const Color(0xFFF8BBD0);

  final List<String> _categories = ['Semua', 'Express', 'Reguler', 'Premium'];

  final List<LaundryService> services = [
    KiloanService(
      "Cuci Kiloan",
      15000,
      "2 hari",
      "Cuci kiloan dengan deterjen premium & pewangi lembut.",
    ),
    SetrikaService(
      "Setrika Saja",
      7000,
      "1 hari",
      "Setrika uap agar pakaian wangi dan licin rapi.",
    ),
    DryCleaningService(
      "Dry Cleaning",
      25000,
      "3 hari",
      "Dry cleaning premium untuk pakaian berbahan khusus.",
    ),
  ];

  void _addToCart(LaundryService item) {
    globalCart.addItem(item.name, item.price);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} ditambahkan ke keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      ServicePage(email: widget.email),
      OrdersPage(email: widget.email),
      ProfilePage(
        email: widget.email,
        telepon: '08123456789',
        alamat: 'Jl. Contoh No.1',
        memberSejak: '2024',
        namaPengguna: '${widget.user.email}',
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: const Color(0xFFEDE7F6),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  /// ------------------- HOME CONTENT -------------------
  Widget _buildHomeContent() {
    final filteredServices = _selectedChip == 0
        ? services
        : services.where((s) {
            if (_selectedChip == 1) return s is SetrikaService;
            if (_selectedChip == 2) return s is KiloanService;
            if (_selectedChip == 3) return s is DryCleaningService;
            return true;
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pastelBlue,
        elevation: 0,
        title: Text(
          'BubbleWash',
          style: GoogleFonts.pacifico(
            textStyle: const TextStyle(fontSize: 28, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_offer_outlined, color: Colors.white),
            tooltip: 'Promo',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PromoPage()),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                tooltip: 'Checkout',
                onPressed: () {
                  if (globalCart.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Keranjang masih kosong')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutPage(cartItems: globalCart.items),
                    ),
                  );
                },
              ),
              if (!globalCart.isEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${globalCart.totalQty}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pastelBlue, pastelPink],
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
                // ======= Greeting user =======
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white30,
                      radius: 28,
                      child: Icon(Icons.person, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.user.greeting(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ======= Banner Promo =======
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF8BBD0), Color(0xFFA7C7E7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.tags,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Promo Spesial! 🎉\nDiskon 20% untuk Cuci Kiloan minggu ini.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ======= Filter kategori =======
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_categories.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_categories[index]),
                          labelStyle: GoogleFonts.poppins(
                            color: _selectedChip == index
                                ? Colors.white
                                : Colors.black87,
                          ),
                          selected: _selectedChip == index,
                          selectedColor: pastelPink,
                          backgroundColor: Colors.white,
                          onSelected: (_) =>
                              setState(() => _selectedChip = index),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                // ======= Daftar Layanan =======
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredServices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = filteredServices[index];
                    return _ServiceCard(
                      icon: FontAwesomeIcons.soap,
                      title: item.name,
                      color: pastelBlue.withOpacity(0.85),
                      rating: 4.7,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailPage(service: item),
                          ),
                        );
                      },
                      onAdd: () => _addToCart(item),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ======= Kenapa Memilih BubbleWash =======
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: pastelBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kenapa Memilih BubbleWash?",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _ReasonTile(
                        icon: FontAwesomeIcons.clock,
                        text: "Layanan cepat & tepat waktu",
                      ),
                      const _ReasonTile(
                        icon: FontAwesomeIcons.leaf,
                        text: "Deterjen ramah lingkungan",
                      ),
                      const _ReasonTile(
                        icon: FontAwesomeIcons.star,
                        text: "Hasil wangi & pakaian rapi",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ======= Testimoni Pelanggan =======
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: pastelPink.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Testimoni Pelanggan",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _TestimonialCard(
                        name: "Rani",
                        comment:
                            "Pakai BubbleWash beneran praktis! Baju jadi wangi & super rapi.",
                        rating: 5,
                      ),
                      const _TestimonialCard(
                        name: "Dimas",
                        comment:
                            "Layanan cepat, staf ramah, dan hasil cucian memuaskan!",
                        rating: 4,
                      ),
                      const _TestimonialCard(
                        name: "Clara",
                        comment:
                            "Dry cleaning terbaik, pakaian bahan khusus tetap aman.",
                        rating: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------- SERVICE CARD -------------------
class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final double rating;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.rating,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            FaIcon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------- REASON TILE -------------------
class _ReasonTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ReasonTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pinkAccent,
          child: FaIcon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// ------------------- TESTIMONIAL CARD -------------------
class _TestimonialCard extends StatelessWidget {
  final String name;
  final String comment;
  final int rating;

  const _TestimonialCard({
    required this.name,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFF8BBD0),
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                RatingBar.readOnly(
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  initialRating: 4,
                  maxRating: 5,
                ),
                const SizedBox(height: 6),
                Text(
                  comment,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
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

import 'package:flutter/material.dart';

/// =======================================================
/// MODEL: Promo (Encapsulation)
/// =======================================================
class Promo {
  String _title;
  String _description;
  String _code;
  String _expiry;
  String _terms;
  String _badge;
  Color _badgeColor;

  Promo({
    required String title,
    required String description,
    required String code,
    required String expiry,
    required String terms,
    required String badge,
    required Color badgeColor,
  })  : _title = title,
        _description = description,
        _code = code,
        _expiry = expiry,
        _terms = terms,
        _badge = badge,
        _badgeColor = badgeColor;

  String get title => _title;
  set title(String v) {
    if (v.isEmpty) throw ArgumentError('Judul promo tidak boleh kosong');
    _title = v;
  }

  String get description => _description;
  set description(String v) {
    if (v.isEmpty) throw ArgumentError('Deskripsi tidak boleh kosong');
    _description = v;
  }

  String get code => _code;
  set code(String v) {
    if (v.isEmpty) throw ArgumentError('Kode tidak boleh kosong');
    _code = v;
  }

  String get expiry => _expiry;
  set expiry(String v) {
    if (v.isEmpty) throw ArgumentError('Tanggal berlaku tidak boleh kosong');
    _expiry = v;
  }

  String get terms => _terms;
  set terms(String v) {
    if (v.isEmpty) throw ArgumentError('Syarat & ketentuan tidak boleh kosong');
    _terms = v;
  }

  String get badge => _badge;
  Color get badgeColor => _badgeColor;

  String getPromoSummary() =>
      "$_title - Kode: $_code - Berlaku sampai $_expiry";
}

/// =======================================================
/// MODEL TURUNAN: LimitedPromo (Inheritance + Polymorphism)
/// =======================================================
class LimitedPromo extends Promo {
  final int maxUsage;

  LimitedPromo({
    required String title,
    required String description,
    required String code,
    required String expiry,
    required String terms,
    required String badge,
    required Color badgeColor,
    required this.maxUsage,
  }) : super(
          title: title,
          description: description,
          code: code,
          expiry: expiry,
          terms: terms,
          badge: badge,
          badgeColor: badgeColor,
        );

  @override
  String getPromoSummary() =>
      "${super.getPromoSummary()} • Maksimal $maxUsage kali penggunaan";
}

/// =======================================================
/// PAGE: Daftar Promo
/// =======================================================
class PromoPage extends StatelessWidget {
  PromoPage({super.key});

  final List<Promo> promos = [
    Promo(
      title: "Diskon 30% Cuci Kiloan",
      description: "Berlaku untuk pelanggan baru, minimal 3kg",
      code: "NEWUSER30",
      expiry: "31 Des 2024",
      terms: "Minimal pembelian 3kg, tidak dapat digabung dengan promo lain",
      badge: "30%",
      badgeColor: Colors.purpleAccent,
    ),
    Promo(
      title: "Gratis Antar-Jemput",
      description: "Tanpa biaya antar-jemput untuk pesanan diatas 50rb",
      code: "FREEDELIVERY",
      expiry: "30 Nov 2024",
      terms: "Minimal pembelian Rp 50.000, radius maksimal 5km",
      badge: "FREE",
      badgeColor: Colors.green,
    ),
    LimitedPromo(
      title: "Flash Sale Weekend",
      description: "Diskon hingga 25% semua layanan di akhir pekan",
      code: "WEEKEND25",
      expiry: "Setiap akhir pekan",
      terms: "Berlaku untuk semua layanan selama akhir pekan",
      badge: "25%",
      badgeColor: Colors.deepOrange,
      maxUsage: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Promo & Diskon"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA7C7E7), Color(0xFFF8BBD0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final p = promos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul + Badge kanan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_offer,
                              color: Colors.pink, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            p.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: p.badgeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          p.badge,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text("Kode: ${p.code}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 4),
                  Text("Berlaku hingga: ${p.expiry}",
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text("S&K: ${p.terms}",
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),

                  // ✅ Tombol return ke CheckoutPage
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.pop(context, p); // kirim promo balik
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Promo dipilih: ${p.title}")),
                        );
                      },
                      child: const Text("Gunakan Promo"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

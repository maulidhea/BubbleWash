// models/global_cart.dart
// ===== Encapsulation keranjang =====
class GlobalCart {
  final List<Map<String, dynamic>> _items = [];

  /// Baca isi keranjang (tidak bisa dimodifikasi langsung dari luar)
  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  /// Tambah item baru atau update qty jika sudah ada
  void addItem(String name, int price) {
    final index = _items.indexWhere((e) => e['name'] == name);
    if (index >= 0) {
      _items[index]['qty'] = (_items[index]['qty'] ?? 1) + 1;
    } else {
      _items.add({'name': name, 'price': price, 'qty': 1});
    }
  }

  bool get isEmpty => _items.isEmpty;

  /// Total semua quantity
  int get totalQty =>
      _items.fold<int>(0, (sum, e) => sum + (e['qty'] as int));

  /// Hapus semua item
  void clear() => _items.clear();
}

/// ✅ Instance global yang bisa dipakai seluruh aplikasi
final globalCart = GlobalCart();

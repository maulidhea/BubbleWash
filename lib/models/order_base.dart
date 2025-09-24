// lib/models/order_base.dart
import 'order_item.dart';

/// ============================================================
/// Abstract Class : BaseOrder
/// ------------------------------------------------------------
/// - Parent class untuk semua jenis pesanan (contoh: LaundryOrder)
/// - Menggunakan prinsip OOP:
///     • Encapsulation: field dibuat private + getter
///     • Inheritance: akan diturunkan ke class lain
///     • Polymorphism: method cetakNota wajib di-override
/// ============================================================
abstract class BaseOrder {
  // -----------------------
  // 🔒 Private Field (Encapsulation)
  // -----------------------
  final String _id;           // ID pesanan
  final String _email;        // email pemesan
  final List<OrderItem> _items; // daftar item pesanan

  // -----------------------
  // 🔧 Constructor
  // -----------------------
  BaseOrder(
    this._id,
    this._email,
    this._items,
  );

  // -----------------------
  // ✅ Getter : akses aman ke field private
  // -----------------------
  String get id => _id;
  String get email => _email;

  /// Kembalikan list item dalam keadaan read-only agar tidak bisa dimodifikasi
  List<OrderItem> get items => List.unmodifiable(_items);

  // -----------------------
  // 🎯 Polymorphism :
  //    Setiap subclass (contoh: LaundryOrder) wajib override
  // -----------------------
  String cetakNota();
}

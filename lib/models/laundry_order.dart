// lib/models/laundry_order.dart
// -----------------------------
// Model utama untuk pesanan laundry

import 'order_item.dart';

class LaundryOrder {
  final String id;
  final String email;
  final String status;
  final String estimasi;
  final String paymentMethod;
  final String deliveryMethod;
  final String address;
  final int subtotal;
  final int discount;
  final int total;
  final List<OrderItem> items;

  LaundryOrder({
    required this.id,
    required this.email,
    required this.status,
    required this.estimasi,
    required this.paymentMethod,
    required this.deliveryMethod,
    required this.address,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.items,
  });
}

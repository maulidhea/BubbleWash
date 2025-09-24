class OrderItem {
  final String name;
  final int qty;
  final int price;

  OrderItem({
    required this.name,
    required this.qty,
    required this.price,
  });

  int get subtotal => qty * price;

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] as String,
      qty: map['qty'] as int,
      price: map['price'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'qty': qty,
        'price': price,
      };
}

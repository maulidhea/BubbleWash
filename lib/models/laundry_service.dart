// models/laundry_service.dart
// ====== OOP: Abstract class & Inheritance + Polymorphism ======
abstract class LaundryService {
  final String name;
  final int price;
  final String duration;
  final String description;

  LaundryService(this.name, this.price, this.duration, this.description);

  /// Method polymorphism: setiap jenis service punya cara promosi berbeda
  String promoMessage();

  /// Encapsulation contoh: format harga hanya bisa diakses lewat getter
  String get formattedPrice => 'Rp$price';
}

class KiloanService extends LaundryService {
  KiloanService(String name, int price, String duration, String description)
      : super(name, price, duration, description);

  @override
  String promoMessage() => "Diskon 10% untuk 5kg pertama!";
}

class SetrikaService extends LaundryService {
  SetrikaService(String name, int price, String duration, String description)
      : super(name, price, duration, description);

  @override
  String promoMessage() => "Gratis pewangi untuk setiap setrika!";
}

class DryCleaningService extends LaundryService {
  DryCleaningService(String name, int price, String duration, String description)
      : super(name, price, duration, description);

  @override
  String promoMessage() => "Dry Cleaning premium untuk bahan khusus!";
}
class PaketService extends LaundryService {
  PaketService(String name, int price, String duration, String description)
      : super(name, price, duration, description);

  @override
  String promoMessage() => "Paket hemat untuk layanan lengkap!";
}
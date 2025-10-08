// ===============================================================
//  OOP: Abstract class, Inheritance, Polymorphism, Encapsulation
// ===============================================================

abstract class AppUser {
  final String _email;                
  AppUser(this._email);

  String get email => _email;          // getter agar email tetap read-only
  void login();                        // method abstrak
  String greeting() => "Halo, $_email"; // default greeting
}

// ---------------------- Member User ----------------------------
class MemberUser extends AppUser {
  final String name;
  final String joinedDate;

  MemberUser(String email, this.name, this.joinedDate) : super(email);

  @override
  void login() => print("Member $email login dengan verifikasi tambahan");

  @override
  String greeting() => "Halo, $name 👋";  
}

// ---------------------- Admin User -----------------------------
class AdminUser extends AppUser {
  AdminUser(String email) : super(email);

  @override
  void login() => print("Admin $email login dengan hak akses penuh");

  @override
  String greeting() => "Halo Admin 👋";    
}

// ---------------------- Guest User -----------------------------
class GuestUser extends AppUser {
  final String name;
  GuestUser({String email = "guest@example.com", this.name = "Guest"})
      : super(email);

  @override
  void login() => print("Guest $email login tanpa autentikasi");

  @override
  String greeting() => "Halo, $name 👋";   
}

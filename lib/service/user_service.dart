class UserService {
  UserService._();
  static final UserService instance = UserService._();

  Map<String, String> getUserProfile(String email) {
    return {
      'email': email,
      'nama': 'Nama Pengguna',
      'telepon': '08123456789',
      'alamat': 'Jl. Contoh No.123, Jakarta',
      'memberSejak': 'September 2025',
    };
  }
}

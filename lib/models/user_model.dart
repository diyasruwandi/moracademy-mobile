class UserModel {
  final String id;
  final String nama;
  final String nomorPeserta;
  final String status;
  final String email;
  final String telepon;
  final String bergabungSejak;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.nama,
    required this.nomorPeserta,
    required this.status,
    required this.email,
    required this.telepon,
    required this.bergabungSejak,
    this.avatarUrl = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      nomorPeserta: json['nomor_peserta'] ?? '',
      status: json['status'] ?? '',
      email: json['email'] ?? '',
      telepon: json['telepon'] ?? '',
      bergabungSejak: json['bergabung_sejak'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nomor_peserta': nomorPeserta,
      'status': status,
      'email': email,
      'telepon': telepon,
      'bergabung_sejak': bergabungSejak,
      'avatar_url': avatarUrl,
    };
  }

  /// Dummy user for development
  static UserModel dummy() {
    return UserModel(
      id: '1',
      nama: 'Yanto Zuckerberg',
      nomorPeserta: 'MDN2704032',
      status: 'Magang S1/D4',
      email: 'yantomullet@example.com',
      telepon: '081234567890',
      bergabungSejak: '17 Juli 1945',
    );
  }
}

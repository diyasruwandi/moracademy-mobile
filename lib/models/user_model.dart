class UserModel {
  final String id;
  final String nama;
  final String nomorPeserta;
  final String status;
  final String email;
  final String telepon;
  final String bergabungSejak;
  final String avatarUrl;
  final String institusi;
  final String jurusan;
  final String perusahaan;

  UserModel({
    required this.id,
    required this.nama,
    required this.nomorPeserta,
    required this.status,
    required this.email,
    required this.telepon,
    required this.bergabungSejak,
    this.avatarUrl = '',
    this.institusi = '',
    this.jurusan = '',
    this.perusahaan = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Cek jika format data dibungkus objek {user, peserta, magang}
    final userObj = json['user'] is Map ? json['user'] as Map<String, dynamic> : json;
    final pesertaObj = json['peserta'] is Map ? json['peserta'] as Map<String, dynamic> : json;
    final magangObj = json['magang'] is Map ? json['magang'] as Map<String, dynamic> : {};
    final perusahaanObj = magangObj['perusahaan'] is Map ? magangObj['perusahaan'] as Map<String, dynamic> : {};

    final id = userObj['id']?.toString() ?? pesertaObj['id']?.toString() ?? '';
    final nama = userObj['name']?.toString() ?? pesertaObj['nama']?.toString() ?? json['nama']?.toString() ?? 'Peserta Magang';
    final email = userObj['email']?.toString() ?? json['email']?.toString() ?? '';
    final telepon = pesertaObj['telp']?.toString() ?? userObj['phone']?.toString() ?? json['telepon']?.toString() ?? '';
    final nomorPeserta = pesertaObj['nomor_peserta']?.toString() ?? pesertaObj['nim_nis']?.toString() ?? json['nomor_peserta']?.toString() ?? '';
    final bergabungSejak = pesertaObj['bergabung_sejak']?.toString() ?? json['bergabung_sejak']?.toString() ?? '';
    final avatarUrl = pesertaObj['foto_url']?.toString() ?? json['avatar_url']?.toString() ?? '';
    final institusi = pesertaObj['institusi_pendidikan']?.toString() ?? '';
    final jurusan = pesertaObj['jurusan']?.toString() ?? '';
    final status = magangObj['posisi']?.toString() ?? json['status']?.toString() ?? 'Peserta Magang';
    final perusahaan = perusahaanObj['name']?.toString() ?? '';

    return UserModel(
      id: id,
      nama: nama,
      nomorPeserta: nomorPeserta,
      status: status,
      email: email,
      telepon: telepon,
      bergabungSejak: bergabungSejak,
      avatarUrl: avatarUrl,
      institusi: institusi,
      jurusan: jurusan,
      perusahaan: perusahaan,
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
      'institusi': institusi,
      'jurusan': jurusan,
      'perusahaan': perusahaan,
    };
  }

  /// Dummy user fallback
  static UserModel dummy() {
    return UserModel(
      id: '1',
      nama: 'Peserta Moracademy',
      nomorPeserta: 'MDN000001',
      status: 'Peserta Magang',
      email: 'peserta@moracademy.id',
      telepon: '-',
      bergabungSejak: '2026',
    );
  }
}

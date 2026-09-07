class JadwalModel {
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;
  final String tipe; // WFO, WFH

  JadwalModel({
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
    required this.tipe,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      tanggal: json['tanggal'] ?? '',
      jamMasuk: json['jam_masuk'] ?? '',
      jamPulang: json['jam_pulang'] ?? '',
      tipe: json['tipe'] ?? 'WFO',
    );
  }

  static JadwalModel dummy() {
    return JadwalModel(
      tanggal: '26 Agustus 2026',
      jamMasuk: '07:53',
      jamPulang: '16:03',
      tipe: 'WFO',
    );
  }
}

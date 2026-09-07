class PresensiModel {
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;
  final String status; // tepat_waktu, terlambat, tidak_presensi
  final String tipe; // WFO, WFH, IZIN

  PresensiModel({
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
    required this.status,
    required this.tipe,
  });

  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    return PresensiModel(
      tanggal: json['tanggal'] ?? '',
      jamMasuk: json['jam_masuk'] ?? '--:--',
      jamPulang: json['jam_pulang'] ?? '--:--',
      status: json['status'] ?? '',
      tipe: json['tipe'] ?? 'WFO',
    );
  }

  static List<PresensiModel> dummyList() {
    return [
      PresensiModel(
        tanggal: '21 Agustus 2026',
        jamMasuk: '07:53',
        jamPulang: '16:03',
        status: 'tepat_waktu',
        tipe: 'WFO',
      ),
      PresensiModel(
        tanggal: '20 Agustus 2026',
        jamMasuk: '08:15',
        jamPulang: '17:05',
        status: 'terlambat',
        tipe: 'WFH',
      ),
      PresensiModel(
        tanggal: '19 Agustus 2026',
        jamMasuk: '07:45',
        jamPulang: '16:10',
        status: 'tepat_waktu',
        tipe: 'WFO',
      ),
      PresensiModel(
        tanggal: '18 Agustus 2026',
        jamMasuk: '--:--',
        jamPulang: '--:--',
        status: 'tidak_presensi',
        tipe: 'WFO',
      ),
    ];
  }

  static List<PresensiModel> dummyIzinList() {
    return [
      PresensiModel(
        tanggal: '22 Agustus 2026',
        jamMasuk: '--:--',
        jamPulang: '--:--',
        status: 'izin',
        tipe: 'IZIN',
      ),
    ];
  }
}

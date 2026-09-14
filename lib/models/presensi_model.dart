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
    String rawStatus = json['status'] ?? '';
    String derivedTipe = json['tipe'] ?? 'WFO';
    
    final izinStatuses = ['sakit', 'izin pribadi', 'lainnya', 'izin'];
    if (izinStatuses.contains(rawStatus.toLowerCase())) {
      derivedTipe = rawStatus.toUpperCase();
    }

    // Format date from YYYY-MM-DD to DD Month YYYY if needed
    String formattedDate = json['tanggal'] ?? '';
    try {
      if (formattedDate.contains('-')) {
        final date = DateTime.parse(formattedDate);
        final months = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        formattedDate = '${date.day} ${months[date.month - 1]} ${date.year}';
      }
    } catch (_) {}

    return PresensiModel(
      tanggal: formattedDate,
      jamMasuk: json['jam_masuk'] ?? '--:--',
      jamPulang: json['jam_pulang'] ?? '--:--',
      status: rawStatus,
      tipe: derivedTipe,
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

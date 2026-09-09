class LogbookModel {
  final String id;
  final String tanggal;
  final String? tanggalFormatted;
  final String kategori;
  final String judul;
  final String detail;
  final String? lampiran;
  final String? lampiranUrl;
  final int? presensiId;
  final DateTime? createdAt;

  LogbookModel({
    required this.id,
    required this.tanggal,
    this.tanggalFormatted,
    required this.kategori,
    required this.judul,
    required this.detail,
    this.lampiran,
    this.lampiranUrl,
    this.presensiId,
    this.createdAt,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      tanggalFormatted: json['tanggal_formatted']?.toString(),
      kategori: json['kategori']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
      lampiran: json['lampiran']?.toString(),
      lampiranUrl: json['lampiran_url']?.toString() ?? json['lampiran_path']?.toString(),
      presensiId: json['presensi_id'] != null ? int.tryParse(json['presensi_id'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  /// Format tanggal untuk tampilan UI yang rapi
  String get displayTanggal {
    if (tanggalFormatted != null && tanggalFormatted!.isNotEmpty) {
      return tanggalFormatted!;
    }
    final parsed = parsedDate;
    if (parsed != null) {
      const days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu'
      ];
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      final dayName = days[parsed.weekday - 1];
      final monthName = months[parsed.month - 1];
      return '$dayName, ${parsed.day} $monthName ${parsed.year}';
    }
    return tanggal;
  }

  /// Helper untuk memparsing tanggal menjadi DateTime object
  DateTime? get parsedDate {
    if (tanggal.isEmpty) return null;

    // Coba format ISO (yyyy-MM-dd)
    final isoParsed = DateTime.tryParse(tanggal);
    if (isoParsed != null) return isoParsed;

    // Coba regex format tanggal teks (misal: "24 Aug 2026")
    final match =
        RegExp(r'(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})').firstMatch(tanggal);
    if (match != null) {
      const months = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Mei': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Agu': 8,
        'Sep': 9,
        'Oct': 10,
        'Okt': 10,
        'Nov': 11,
        'Dec': 12,
        'Des': 12,
      };
      final monthStr = match.group(2);
      final month = months[monthStr];
      if (month != null) {
        return DateTime(
          int.parse(match.group(3)!),
          month,
          int.parse(match.group(1)!),
        );
      }
    }

    return null;
  }

  static List<LogbookModel> dummyList() {
    return [
      LogbookModel(
        id: '1',
        tanggal: '2026-08-24',
        tanggalFormatted: 'Senin, 24 Agu 2026',
        kategori: 'Software Development',
        judul: 'Fixing SQL Injection & QA Testing',
        detail:
            'Menyelesaikan bug keamanan pada modul login dan melakukan smoke test',
      ),
      LogbookModel(
        id: '2',
        tanggal: '2026-08-21',
        tanggalFormatted: 'Jumat, 21 Agu 2026',
        kategori: 'Software Development',
        judul: 'Implementasi API Payment Gateway',
        detail:
            'Melakukan integrasi API Midtrans untuk proses checkout. Mengalami sedikit kendala signature key.',
      ),
      LogbookModel(
        id: '3',
        tanggal: '2026-08-19',
        tanggalFormatted: 'Rabu, 19 Agu 2026',
        kategori: 'DevOps',
        judul: 'Onboarding & Setup Environment',
        detail:
            'Setup lokal environment (Docker, Node.js), membaca dokumentasi sistem.',
      ),
    ];
  }
}

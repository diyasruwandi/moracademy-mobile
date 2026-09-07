class LogbookModel {
  final String id;
  final String tanggal;
  final String kategori;
  final String judul;
  final String detail;
  final String? lampiranPath;

  LogbookModel({
    required this.id,
    required this.tanggal,
    required this.kategori,
    required this.judul,
    required this.detail,
    this.lampiranPath,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal'] ?? '',
      kategori: json['kategori'] ?? '',
      judul: json['judul'] ?? '',
      detail: json['detail'] ?? '',
      lampiranPath: json['lampiran_path'],
    );
  }

  static List<LogbookModel> dummyList() {
    return [
      LogbookModel(
        id: '1',
        tanggal: 'Senin, 24 Aug 2026',
        kategori: 'Software Development',
        judul: 'Fixing SQL Injection & QA Testing',
        detail:
            'Menyelesaikan bug keamanan pada modul login dan melakukan smoke test',
      ),
      LogbookModel(
        id: '2',
        tanggal: 'Jumat, 21 Aug 2026',
        kategori: 'Software Development',
        judul: 'Implementasi API Payment Gateway',
        detail:
            'Melakukan integrasi API Midtrans untuk proses checkout. Mengalami sedikit...',
      ),
      LogbookModel(
        id: '3',
        tanggal: 'Rabu, 19 Aug 2026',
        kategori: 'DevOps',
        judul: 'Onboarding & Setup Environment',
        detail:
            'Setup lokal environment (Docker, Node.js), membaca dokumentasi...',
      ),
    ];
  }
}

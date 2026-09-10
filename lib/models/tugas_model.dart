import 'package:intl/intl.dart';

class TugasModel {
  final String id;
  final String judul;
  final String pemberiTugas;
  final String penerimaTugas;
  final String deskripsi;
  final String tanggalTugas;
  final String media;
  final String linkTugas;
  final String fileLampiran;
  final String createdAt;

  TugasModel({
    required this.id,
    required this.judul,
    required this.pemberiTugas,
    required this.penerimaTugas,
    required this.deskripsi,
    required this.tanggalTugas,
    required this.media,
    required this.linkTugas,
    required this.fileLampiran,
    required this.createdAt,
  });

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul'] ?? '',
      pemberiTugas: json['pemberi_tugas'] ?? '',
      penerimaTugas: json['penerima_tugas'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tanggalTugas: _formatDate(json['tanggal_tugas']),
      media: json['media'] ?? '',
      linkTugas: json['link_tugas'] ?? '',
      fileLampiran: json['file_lampiran'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  static String _formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return '';
    try {
      final parsed = DateTime.parse(dateStr.toString());
      return DateFormat('dd MMMM yyyy').format(parsed);
    } catch (e) {
      return dateStr.toString();
    }
  }
}

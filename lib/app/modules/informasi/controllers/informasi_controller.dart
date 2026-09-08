import 'package:get/get.dart';

class InformasiController extends GetxController {
  final searchController = ''.obs;
  final isLoading = false.obs;
  final informations = <Map<String, String>>[
    {
      'category': 'Pengumuman',
      'title': 'Pembaruan jadwal kegiatan magang',
      'date': '8 September 2026',
      'detail':
          'Periksa jadwal terbaru dan pastikan kehadiran Anda tercatat sesuai waktu kegiatan.',
    },
    {
      'category': 'Panduan',
      'title': 'Lengkapi logbook harian',
      'date': '5 September 2026',
      'detail':
          'Isi logbook setiap hari dengan judul, kategori, detail kegiatan, dan lampiran bila diperlukan.',
    },
    {
      'category': 'Informasi',
      'title': 'Gunakan presensi sesuai lokasi kegiatan',
      'date': '1 September 2026',
      'detail':
          'Pastikan izin kamera dan lokasi aktif saat melakukan verifikasi presensi.',
    },
  ].obs;

  List<Map<String, String>> get filteredInformations {
    final query = searchController.value.trim().toLowerCase();
    if (query.isEmpty) return informations.toList();

    return informations.where((information) {
      return information.values.any(
        (value) => value.toLowerCase().contains(query),
      );
    }).toList();
  }

  void search(String query) {
    searchController.value = query;
  }
}

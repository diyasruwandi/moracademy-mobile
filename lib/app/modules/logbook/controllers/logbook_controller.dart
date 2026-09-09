import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../../../models/logbook_model.dart';

class LogbookController extends GetxController {
  final selectedFilter = 0.obs; // 0=Minggu Ini, 1=Bulan Ini, 2=Custom
  final logbookList = <LogbookModel>[].obs;
  final customDateRange = Rxn<DateTimeRange>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Entry form
  final tanggalKegiatan = Rxn<DateTime>(DateTime.now());
  final kategoriKegiatan = 'Software Development'.obs;
  final judulController = TextEditingController();
  final detailController = TextEditingController();
  final selectedImagePath = Rxn<String>();
  final selectedImageName = Rxn<String>();

  final _imagePicker = ImagePicker();

  final kategoriOptions = [
    'Software Development',
    'DevOps',
    'QA Testing',
    'UI/UX Design',
    'Data Analysis',
    'Lainnya',
  ];

  @override
  void onInit() {
    super.onInit();
    loadLogbook();
  }

  /// Mengambil riwayat logbook dari server
  Future<void> loadLogbook() async {
    try {
      isLoading.value = true;
      final response = await ApiService.to.getLogbooks();

      if (response.isOk && response.body != null) {
        final body = response.body;
        if (body is Map && body['data'] is List) {
          final List listData = body['data'];
          logbookList.value = listData
              .map((item) => LogbookModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        } else if (body is List) {
          logbookList.value = body
              .map((item) => LogbookModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      } else {
        // Jika server mengembalikan error atau tidak terhubung
        final msg = ApiService.getErrorMessage(response);
        Get.snackbar(
          'Info',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.shade100,
          colorText: Colors.amber.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error loading logbook: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh daftar logbook
  Future<void> refreshLogbook() async {
    await loadLogbook();
  }

  /// Ganti filter tab
  void switchFilter(int index) {
    selectedFilter.value = index;
  }

  /// Filter logbook list berdasarkan tab yang dipilih
  List<LogbookModel> get filteredLogbookList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (selectedFilter.value == 0) {
      // 0 = Minggu Ini (Senin sampai Minggu)
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      return logbookList.where((logbook) {
        final date = logbook.parsedDate;
        if (date == null) return true;
        return !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek);
      }).toList();
    } else if (selectedFilter.value == 1) {
      // 1 = Bulan Ini
      return logbookList.where((logbook) {
        final date = logbook.parsedDate;
        if (date == null) return true;
        return date.year == today.year && date.month == today.month;
      }).toList();
    } else {
      // 2 = Custom Range
      final range = customDateRange.value;
      if (range == null) {
        return logbookList.toList();
      }

      final start = DateTime(range.start.year, range.start.month, range.start.day);
      final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);

      return logbookList.where((logbook) {
        final date = logbook.parsedDate;
        if (date == null) return true;
        return !date.isBefore(start) && !date.isAfter(end);
      }).toList();
    }
  }

  /// Memilih rentang tanggal kustom
  Future<void> selectCustomDateRange(BuildContext context) async {
    final now = DateTime.now();
    final currentRange = customDateRange.value;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: currentRange,
      currentDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF2E3192),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      customDateRange.value = picked;
      selectedFilter.value = 2;
    }
  }

  String get customDateRangeLabel {
    final range = customDateRange.value;
    if (range == null) return 'Custom Range';
    return '${_formatShortDate(range.start)} - ${_formatShortDate(range.end)}';
  }

  String _formatShortDate(DateTime date) {
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
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  /// Memilih tanggal untuk form entry logbook
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalKegiatan.value ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      tanggalKegiatan.value = picked;
    }
  }

  /// Format tanggal penuh (Indonesia)
  String formatDate(DateTime? date) {
    final target = date ?? DateTime.now();
    return _formatFullDate(target);
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Memilih foto dari Galeri atau Kamera
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        selectedImageName.value = pickedFile.name;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Gagal Memilih Gambar',
        'Terjadi kendala saat membuka file gambar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// Menghapus lampiran yang sudah dipilih
  void removeImage() {
    selectedImagePath.value = null;
    selectedImageName.value = null;
  }

  /// Mengirim dan menyimpan logbook baru ke backend Laravel
  Future<void> simpanLogbook() async {
    final judul = judulController.text.trim();
    final detail = detailController.text.trim();

    if (judul.isEmpty || detail.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Judul dan detail kegiatan wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final date = tanggalKegiatan.value ?? DateTime.now();
    final formattedDate =
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      isSubmitting.value = true;

      final response = await ApiService.to.createLogbook(
        tanggal: formattedDate,
        kategori: kategoriKegiatan.value,
        judul: judul,
        detail: detail,
        lampiranPath: selectedImagePath.value,
      );

      if (response.isOk && response.body != null && response.body['success'] == true) {
        // Reset form input
        judulController.clear();
        detailController.clear();
        tanggalKegiatan.value = DateTime.now();
        selectedImagePath.value = null;
        selectedImageName.value = null;
        kategoriKegiatan.value = kategoriOptions.first;

        // Refresh daftar logbook
        await loadLogbook();

        Get.back(); // Kembali ke halaman logbook list

        Get.snackbar(
          'Berhasil Disimpan',
          response.body['message'] ?? 'Catatan logbook berhasil dikirim.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 4),
        );
      } else {
        final errorMsg = ApiService.getErrorMessage(response);
        Get.snackbar(
          'Gagal Menyimpan',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline, color: Colors.red),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Exception saat submit logbook: $e');
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal mengirim data ke server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Menghapus logbook
  Future<void> hapusLogbook(String id) async {
    try {
      final response = await ApiService.to.deleteLogbook(id);
      if (response.isOk) {
        logbookList.removeWhere((item) => item.id == id);
        Get.snackbar(
          'Berhasil',
          'Catatan logbook berhasil dihapus.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          'Gagal',
          ApiService.getErrorMessage(response),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      debugPrint('Error deleting logbook: $e');
    }
  }

  @override
  void onClose() {
    judulController.dispose();
    detailController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/logbook_model.dart';

class LogbookController extends GetxController {
  final selectedFilter = 0.obs; // 0=Minggu Ini, 1=Bulan Ini, 2=Custom
  final logbookList = <LogbookModel>[].obs;
  final isLoading = false.obs;

  // Entry form
  final tanggalKegiatan = Rxn<DateTime>();
  final kategoriKegiatan = 'Software Development'.obs;
  final judulController = TextEditingController();
  final detailController = TextEditingController();

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

  void loadLogbook() {
    logbookList.value = LogbookModel.dummyList();
  }

  void switchFilter(int index) {
    selectedFilter.value = index;
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      tanggalKegiatan.value = picked;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Hari ini, ${_formatFullDate(DateTime.now())}';
    return _formatFullDate(date);
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void simpanLogbook() {
    if (judulController.text.isEmpty || detailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Judul dan detail kegiatan harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Logbook berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  @override
  void onClose() {
    judulController.dispose();
    detailController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IzinController extends GetxController {
  final jenisIzin = 'Sakit'.obs;
  final tanggalMulai = Rxn<DateTime>();
  final tanggalSelesai = Rxn<DateTime>();
  final keteranganController = TextEditingController();
  final isLoading = false.obs;

  final jenisIzinOptions = ['Sakit', 'Izin Pribadi', 'Cuti', 'Dinas Luar'];

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isStart) {
        tanggalMulai.value = picked;
      } else {
        tanggalSelesai.value = picked;
      }
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  void ajukanIzin() {
    if (tanggalMulai.value == null || tanggalSelesai.value == null) {
      Get.snackbar(
        'Error',
        'Tanggal mulai dan selesai harus diisi',
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
        'Izin berhasil diajukan',
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
    keteranganController.dispose();
    super.onClose();
  }
}

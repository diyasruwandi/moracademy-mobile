import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';

class IzinController extends GetxController {
  final jenisIzin = 'Sakit'.obs;
  final tanggalMulai = Rxn<DateTime>();
  final tanggalSelesai = Rxn<DateTime>();
  final keteranganController = TextEditingController();
  final isLoading = false.obs;
  final lampiranPath = RxnString();

  final jenisIzinOptions = ['Sakit', 'Izin Pribadi', 'Lainnya'];
  final ImagePicker _picker = ImagePicker();

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

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      lampiranPath.value = pickedFile.path;
    }
  }

  Future<void> ajukanIzin() async {
    if (tanggalMulai.value == null || tanggalSelesai.value == null) {
      Get.snackbar(
        'Peringatan',
        'Tanggal mulai dan selesai harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (tanggalSelesai.value!.isBefore(tanggalMulai.value!)) {
      Get.snackbar(
        'Peringatan',
        'Tanggal selesai tidak boleh sebelum tanggal mulai',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    
    // Show full screen loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      barrierDismissible: false,
    );

    try {
      final tglMulai = '${tanggalMulai.value!.year}-${tanggalMulai.value!.month.toString().padLeft(2, '0')}-${tanggalMulai.value!.day.toString().padLeft(2, '0')}';
      final tglSelesai = '${tanggalSelesai.value!.year}-${tanggalSelesai.value!.month.toString().padLeft(2, '0')}-${tanggalSelesai.value!.day.toString().padLeft(2, '0')}';

      final formMap = <String, dynamic>{
        'jenis_izin': jenisIzin.value,
        'tanggal_mulai': tglMulai,
        'tanggal_selesai': tglSelesai,
        'keterangan': keteranganController.text,
      };

      if (lampiranPath.value != null && lampiranPath.value!.isNotEmpty) {
        final filePath = lampiranPath.value!;
        final filename = filePath.split(Platform.pathSeparator).last;
        formMap['bukti_foto'] = MultipartFile(File(filePath), filename: filename);
      }

      final formData = FormData(formMap);
      final response = await ApiService.to.ajukanIzin(formData);

      if (response.isOk) {
        Get.back(); // close loading
        Get.back(); // return to previous page
        Get.snackbar(
          'Berhasil',
          'Izin berhasil diajukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.back(); // close loading
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
      Get.back(); // close loading
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_snackbar.dart';

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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 1024,
    );
    if (pickedFile != null) {
      lampiranPath.value = pickedFile.path;
    }
  }

  Future<void> ajukanIzin() async {
    if (tanggalMulai.value == null || tanggalSelesai.value == null) {
      AppSnackbar.showWarning(
          'Peringatan', 'Tanggal mulai dan selesai harus diisi!');
      return;
    }

    if (tanggalSelesai.value!.isBefore(tanggalMulai.value!)) {
      AppSnackbar.showWarning(
          'Peringatan', 'Tanggal selesai tidak boleh sebelum tanggal mulai');
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
      final tglMulai =
          '${tanggalMulai.value!.year}-${tanggalMulai.value!.month.toString().padLeft(2, '0')}-${tanggalMulai.value!.day.toString().padLeft(2, '0')}';
      final tglSelesai =
          '${tanggalSelesai.value!.year}-${tanggalSelesai.value!.month.toString().padLeft(2, '0')}-${tanggalSelesai.value!.day.toString().padLeft(2, '0')}';

      final formMap = <String, dynamic>{
        'jenis_izin': jenisIzin.value,
        'tanggal_mulai': tglMulai,
        'tanggal_selesai': tglSelesai,
        'keterangan': keteranganController.text,
      };

      if (lampiranPath.value != null && lampiranPath.value!.isNotEmpty) {
        final filePath = lampiranPath.value!;
        final filename = filePath.split(Platform.pathSeparator).last;
        final file = File(filePath);
        final bytes = file.readAsBytesSync();
        formMap['bukti_foto'] = MultipartFile(bytes, filename: filename);
      }

      final formData = FormData(formMap);
      final response = await ApiService.to.ajukanIzin(formData);

      if (response.isOk) {
        Get.back(); // close loading
        Get.back(); // return to previous page
        // Show success notification after navigation settles
        Future.delayed(const Duration(milliseconds: 500), () {
          AppSnackbar.showSuccess('Berhasil', 'Izin berhasil diajukan');
        });
      } else {
        Get.back(); // close loading
        AppSnackbar.showError('Gagal', ApiService.getErrorMessage(response));
      }
    } catch (e) {
      Get.back(); // close loading
      AppSnackbar.showError('Error', 'Terjadi kesalahan: $e');
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

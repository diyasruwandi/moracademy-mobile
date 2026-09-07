import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresensiController extends GetxController {
  final isLocationVerified = true.obs;
  final isScheduleFound = true.obs;
  final isRadiusValid = true.obs;
  final isAllVerified = true.obs;
  final isLoading = false.obs;

  void presensiMasuk() {
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Presensi masuk berhasil dicatat',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  void presensiPulang() {
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Presensi pulang berhasil dicatat',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
}

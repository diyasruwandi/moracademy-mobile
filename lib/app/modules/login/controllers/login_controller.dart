import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../../../../core/services/api_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Email harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Peringatan',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.to.requestOtp(email);
      isLoading.value = false;

      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final message = response.body['message'] ?? 'Kode OTP berhasil dikirimkan.';
        Get.snackbar(
          'Berhasil',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
        Get.toNamed(Routes.OTP, arguments: {'email': email});
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        Get.snackbar(
          'Gagal Masuk',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan koneksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void goToBantuan() {
    Get.toNamed(Routes.BANTUAN);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

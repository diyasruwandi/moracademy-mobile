import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      AppSnackbar.showWarning('Peringatan', 'Email harus diisi');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.showWarning('Peringatan', 'Format email tidak valid');
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.to.requestOtp(email);
      isLoading.value = false;

      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final message = response.body['message'] ?? 'Kode OTP berhasil dikirimkan.';
        // Navigate first to avoid race condition with snackbar overlay
        Get.toNamed(Routes.OTP, arguments: {'email': email});
        // Show success notification after navigation completes
        Future.delayed(const Duration(milliseconds: 500), () {
          AppSnackbar.showSuccess('Berhasil', message);
        });
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        AppSnackbar.showError('Gagal Masuk', errorMessage);
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.showError('Error', 'Terjadi kesalahan koneksi: ${e.toString()}');
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

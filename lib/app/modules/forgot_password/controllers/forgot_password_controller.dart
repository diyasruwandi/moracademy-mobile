import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  void resetPassword() {
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor telepon harus diisi',
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
      Get.toNamed(Routes.FORGOT_PASSWORD_SUCCESS);
    });
  }

  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';

import '../../../../core/utils/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  void resetPassword() {
    if (phoneController.text.isEmpty) {
      AppSnackbar.showError('Error', 'Nomor telepon harus diisi');
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

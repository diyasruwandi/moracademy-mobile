import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  
  final email = ''.obs;
  final otpCode = ''.obs;
  final isLoading = false.obs;
  final resendCountdown = 60.obs;
  final canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('email')) {
      email.value = args['email'] as String;
    } else {
      email.value = 'peserta@moracademy.id';
    }

    otpController.addListener(() {
      otpCode.value = otpController.text;
      if (otpController.text.length == 6 && !isLoading.value) {
        verifyOtp();
      }
    });

    startResendTimer();
  }

  void startResendTimer() {
    _timer?.cancel();
    resendCountdown.value = 60;
    canResend.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResend.value || isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService.to.requestOtp(email.value);
      isLoading.value = false;

      if (response.isOk && response.body is Map && response.body['success'] == true) {
        startResendTimer();
        final message = response.body['message'] ?? 'Kode OTP baru telah dikirimkan.';
        Get.snackbar(
          'Berhasil',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        Get.snackbar(
          'Gagal Mengirim OTP',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
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

  Future<void> verifyOtp() async {
    final code = otpController.text.trim();
    if (code.length < 6) {
      Get.snackbar(
        'Peringatan',
        'Masukkan 6 digit kode OTP lengkap',
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
      final response = await ApiService.to.verifyOtp(email.value, code);
      isLoading.value = false;

      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final data = response.body['data'];
        if (data is Map) {
          final token = data['token']?.toString() ?? '';
          final user = data['user'] as Map<String, dynamic>?;
          final peserta = data['peserta'] as Map<String, dynamic>?;
          final magang = data['magang'] as Map<String, dynamic>?;

          if (Get.isRegistered<StorageService>()) {
            await StorageService.to.saveAuthSession(
              authToken: token,
              user: user,
              peserta: peserta,
              magang: magang,
            );
          }
        }

        final message = response.body['message'] ?? 'Verifikasi berhasil! Selamat datang.';
        Get.snackbar(
          'Berhasil',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed(Routes.MAIN_NAV);
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        Get.snackbar(
          'Verifikasi Gagal',
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

  void changeEmail() {
    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}


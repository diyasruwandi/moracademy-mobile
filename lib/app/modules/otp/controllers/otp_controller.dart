import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_snackbar.dart';

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

      if (response.isOk &&
          response.body is Map &&
          response.body['success'] == true) {
        startResendTimer();
        final message =
            response.body['message'] ?? 'Kode OTP baru telah dikirimkan.';
        AppSnackbar.showSuccess('Berhasil', message);
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        AppSnackbar.showError('Gagal Mengirim OTP', errorMessage);
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.showError('Error', 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<void> verifyOtp() async {
    final code = otpController.text.trim();
    if (code.length < 6) {
      AppSnackbar.showWarning(
          'Peringatan', 'Masukkan 6 digit kode OTP lengkap');
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.to.verifyOtp(email.value, code);
      isLoading.value = false;

      if (response.isOk &&
          response.body is Map &&
          response.body['success'] == true) {
        final data = response.body['data'];
        if (data is Map) {
          final token = data['token']?.toString() ?? '';
          final user = data['user'] as Map<String, dynamic>?;
          final peserta = data['peserta'] as Map<String, dynamic>?;
          final magang = data['magang'] as Map<String, dynamic>?;

          print(
              "💾 [OTP] Menyimpan sesi ke SharedPreferences... Token: $token");
          await StorageService.to.saveAuthSession(
            authToken: token,
            user: user,
            peserta: peserta,
            magang: magang,
          );
          print("✅ [OTP] Sesi berhasil disimpan!");
        }

        final message =
            response.body['message'] ?? 'Verifikasi berhasil! Selamat datang.';
        // Navigate first to avoid race condition with snackbar overlay
        Get.offAllNamed(Routes.MAIN_NAV);
        // Show success notification after navigation completes
        Future.delayed(const Duration(milliseconds: 500), () {
          AppSnackbar.showSuccess('Berhasil', message);
        });
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        AppSnackbar.showError('Gagal Verifikasi', errorMessage);
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.showError(
          'Error', 'Terjadi kesalahan koneksi: ${e.toString()}');
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

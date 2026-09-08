import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/api_service.dart';

class PresensiController extends GetxController {
  final isLocationVerified = false.obs;
  final isScheduleFound = true.obs;
  final isRadiusValid = false.obs;
  final isAllVerified = false.obs;
  final isLoading = false.obs;
  final hasScannedQr = false.obs;
  final currentPosition = Rxn<Position>();
  final isLocationLoading = false.obs;
  final locationMessage = 'Mencari lokasi perangkat...'.obs;

  // Status presensi hari ini
  final hasMasuk = false.obs;
  final hasPulang = false.obs;
  final jamMasuk = Rxn<String>();
  final jamPulang = Rxn<String>();
  final isCheckingToday = false.obs;

  // Token QR yang di-scan
  String? scannedQrToken;

  @override
  void onInit() {
    super.onInit();
    loadCurrentLocation();
    checkTodayPresensi();
  }

  /// Cek status presensi hari ini dari backend
  Future<void> checkTodayPresensi() async {
    isCheckingToday.value = true;
    try {
      final response = await ApiService.to.checkTodayPresensi();
      if (response.isOk &&
          response.body is Map &&
          response.body['success'] == true) {
        final data = response.body['data'];
        if (data is Map) {
          hasMasuk.value = data['has_masuk'] == true;
          hasPulang.value = data['has_pulang'] == true;
          jamMasuk.value = data['jam_masuk'];
          jamPulang.value = data['jam_pulang'];
        }
      }
    } catch (_) {
      // Gagal cek status, biarkan default (belum presensi)
    }
    isCheckingToday.value = false;
  }

  Future<void> loadCurrentLocation() async {
    isLocationLoading.value = true;
    isLocationVerified.value = false;
    isRadiusValid.value = false;
    isAllVerified.value = false;
    locationMessage.value = 'Mencari lokasi perangkat...';

    if (!await Geolocator.isLocationServiceEnabled()) {
      locationMessage.value = 'GPS sedang tidak aktif';
      isLocationLoading.value = false;
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      locationMessage.value = 'Izin lokasi belum diberikan';
      isLocationLoading.value = false;
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition.value = position;
      isLocationVerified.value = true;
      isRadiusValid.value = position.accuracy <= 50;
      isAllVerified.value = isLocationVerified.value && isRadiusValid.value;
      locationMessage.value =
          'Lokasi ditemukan (akurasi +/- ${position.accuracy.toStringAsFixed(0)} m)';
    } catch (_) {
      locationMessage.value = 'Lokasi tidak dapat ditemukan';
    }
    isLocationLoading.value = false;
  }

  void resetScanner() {
    hasScannedQr.value = false;
    scannedQrToken = null;
  }

  /// Dipanggil setelah QR code berhasil di-scan
  /// Backend otomatis menentukan: masuk atau pulang
  Future<void> scanAndSubmit(String qrToken) async {
    if (isLoading.value || hasScannedQr.value) return;
    hasScannedQr.value = true;
    isLoading.value = true;
    scannedQrToken = qrToken;

    final position = currentPosition.value;
    if (position == null) {
      isLoading.value = false;
      hasScannedQr.value = false;
      Get.snackbar(
        'Gagal',
        'Lokasi belum tersedia. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      final response = await ApiService.to.scanPresensi(
        qrToken: qrToken,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      isLoading.value = false;

      if (response.isOk &&
          response.body is Map &&
          response.body['success'] == true) {
        final message =
            response.body['message'] ?? 'Presensi berhasil dicatat';

        // Refresh status presensi hari ini
        await checkTodayPresensi();

        Get.back(); // Kembali dari scanner ke verifikasi
        Get.snackbar(
          'Berhasil ✅',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
      } else {
        hasScannedQr.value = false;
        final errorMessage = ApiService.getErrorMessage(response);
        Get.back(); // Kembali dari scanner
        Get.snackbar(
          'Gagal',
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
      hasScannedQr.value = false;
      Get.back();
      Get.snackbar(
        'Error',
        'Gagal terhubung ke server: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

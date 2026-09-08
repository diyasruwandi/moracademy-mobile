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
  String? scannedQrToken;

  // Status Presensi Hari Ini
  final hasMasuk = false.obs;
  final hasPulang = false.obs;
  final jamMasuk = RxnString();
  final jamPulang = RxnString();
  final isCheckingToday = false.obs;


  @override
  void onInit() {
    super.onInit();
    loadCurrentLocation();

    checkTodayStatus();
  }

  Future<void> checkTodayStatus() async {
    isCheckingToday.value = true;
    try {
      final response = await ApiService.to.checkTodayPresensi();
      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final data = response.body['data'];
        if (data is Map) {
          hasMasuk.value = data['has_masuk'] == true;
          hasPulang.value = data['has_pulang'] == true;

          jamMasuk.value = data['jam_masuk']?.toString();
          jamPulang.value = data['jam_pulang']?.toString();
        }
      }
    } catch (_) {}
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

  /// Memproses token QR yang di-scan kamera dan kirim ke API QR Moracademy
  Future<void> scanQrPresensi(String qrToken) async {
    if (isLoading.value || hasScannedQr.value) return;
    hasScannedQr.value = true;
    isLoading.value = true;

    try {
      // Pastikan ada posisi GPS
      Position? position = currentPosition.value;
      if (position == null) {
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );
          currentPosition.value = position;
        } catch (_) {}
      }

      final lat = position?.latitude ?? -7.782819;
      final lng = position?.longitude ?? 110.367082;

      final response = await ApiService.to.scanPresensi(
        qrToken: qrToken,
        latitude: lat,
        longitude: lng,
      );

      isLoading.value = false;

      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final message = response.body['message'] ?? 'Presensi berhasil dicatat.';
        Get.back(); // Tutup scanner kamera
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
        // Refresh status presensi
        checkTodayStatus();
      } else {
        final errorMessage = ApiService.getErrorMessage(response);
        Get.snackbar(
          'Gagal Presensi',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
        // Izinkan scan ulang jika gagal
        Future.delayed(const Duration(seconds: 2), () {
          hasScannedQr.value = false;
        });
      }
    } catch (e) {
      isLoading.value = false;
      hasScannedQr.value = false;
      Get.snackbar(
        'Error',
        'Gagal memproses presensi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

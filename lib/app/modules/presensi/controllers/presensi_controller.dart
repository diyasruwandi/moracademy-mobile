import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void onInit() {
    super.onInit();
    loadCurrentLocation();
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
  }

  void presensiMasuk() {
    if (isLoading.value || hasScannedQr.value) return;
    hasScannedQr.value = true;
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../controllers/presensi_controller.dart';

class VerifikasiView extends GetView<PresensiController> {
  const VerifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Presensi'),
      body: Column(
        children: [
          // Live device location map
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Obx(
                () => controller.currentPosition.value == null
                    ? _locationState()
                    : _buildLocationMap(controller.currentPosition.value!),
              ),
            ),
          ),
          // Verification info
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _verificationItem(
                        Icons.location_on,
                        controller.locationMessage.value,
                        controller.isLocationVerified.value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _verificationItem(
                      Icons.check_circle,
                      'Jadwal kerja ditemukan',
                      true,
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _verificationItem(
                        Icons.my_location,
                        controller.isRadiusValid.value
                            ? 'Akurasi GPS memadai untuk presensi'
                            : 'Akurasi GPS belum memadai (maks. 50 m)',
                        controller.isRadiusValid.value,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status presensi hari ini
                    Obx(() {
                      if (controller.isCheckingToday.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      // Jika user sedang izin hari ini
                      if (controller.hasIzin.value) {
                        final status = controller.izinStatus.value ?? 'Izin';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.event_busy,
                                  color: Colors.orange.shade700, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Anda sedang izin hari ini (${status[0].toUpperCase()}${status.substring(1)})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final hasMasuk = controller.hasMasuk.value;
                      final hasPulang = controller.hasPulang.value;

                      if (!hasMasuk && !hasPulang) {
                        return Center(
                          child: Text(
                            'Belum ada presensi hari ini',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textHint,
                            ),
                          ),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (hasMasuk) ...[
                            Icon(Icons.login,
                                size: 16, color: Colors.green.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Masuk: ${controller.jamMasuk.value ?? "-"}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                          if (hasMasuk && hasPulang) const SizedBox(width: 16),
                          if (hasPulang) ...[
                            Icon(Icons.logout,
                                size: 16, color: Colors.orange.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Pulang: ${controller.jamPulang.value ?? "-"}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ],
                      );
                    }),

                    const SizedBox(height: 16),

                    // Tombol Presensi Masuk — aktif hanya jika lokasi valid DAN belum masuk DAN tidak izin DAN tidak disable
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () {
                          final sudahMasuk = controller.hasMasuk.value;
                          final sedangIzin = controller.hasIzin.value;
                          final isLateDisabled =
                              controller.isDisabledMasuk.value;
                          final adaJadwal = controller.hasJadwal.value;
                          final canMasuk = !controller.isCheckingToday.value &&
                              controller.isAllVerified.value &&
                              !sudahMasuk &&
                              !sedangIzin &&
                              !isLateDisabled &&
                              adaJadwal;

                          return ElevatedButton(
                            onPressed: canMasuk
                                ? () async {
                                    final result =
                                        await ConfirmationDialog.show(
                                      context,
                                      message:
                                          'Anda akan melakukan presensi masuk?',
                                    );
                                    if (result == true) {
                                      controller.resetScanner();
                                      Get.toNamed(Routes.PRESENSI);
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              controller.isCheckingToday.value
                                  ? 'Memeriksa status...'
                                  : !adaJadwal
                                      ? 'Tidak Ada Jadwal Aktif'
                                      : sedangIzin
                                          ? 'Tidak dapat presensi (Izin)'
                                          : isLateDisabled
                                              ? 'Presensi Masuk Ditutup (Melewati Jam Pulang)'
                                              : sudahMasuk
                                                  ? 'Sudah Masuk (${controller.jamMasuk.value ?? ''})'
                                                  : 'Presensi masuk',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Presensi Pulang button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () {
                          final sudahMasuk = controller.hasMasuk.value;
                          final sudahPulang = controller.hasPulang.value;
                          final sedangIzin = controller.hasIzin.value;
                          final canPulang = !controller.isCheckingToday.value &&
                              controller.isAllVerified.value &&
                              sudahMasuk &&
                              !sudahPulang &&
                              !sedangIzin;

                          return ElevatedButton(
                            onPressed: canPulang
                                ? () async {
                                    final now = DateTime.now();
                                    final nowTimeStr =
                                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                                    final jadwalPulangStr =
                                        controller.jadwalPulang.value ??
                                            '16:00';

                                    if (nowTimeStr.compareTo(jadwalPulangStr) <
                                        0) {
                                      // Pulang Cepat
                                      final textController =
                                          TextEditingController();
                                      final result = await Get.dialog<bool>(
                                        AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          title: const Text('Pulang Cepat',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Jam pulang Anda hari ini adalah $jadwalPulangStr. Silakan berikan alasan jika Anda harus pulang lebih awal.'),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller: textController,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Contoh: Ada urusan keluarga...',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Get.back(result: false),
                                              child: Text('Batal',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .grey.shade600)),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (textController.text
                                                    .trim()
                                                    .isEmpty) {
                                                  Get.snackbar(
                                                    'Peringatan',
                                                    'Alasan pulang cepat wajib diisi!',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor:
                                                        Colors.orange.shade100,
                                                    colorText:
                                                        Colors.orange.shade800,
                                                  );
                                                  return;
                                                }
                                                Get.back(result: true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                              ),
                                              child: const Text('Lanjutkan'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (result == true) {
                                        controller.alasanPulangCepat.value =
                                            textController.text.trim();
                                        controller.resetScanner();
                                        Get.toNamed(Routes.PRESENSI);
                                      }
                                    } else {
                                      // Pulang normal
                                      final result =
                                          await ConfirmationDialog.show(
                                        context,
                                        message:
                                            'Anda akan melakukan presensi pulang?',
                                      );
                                      if (result == true) {
                                        controller.alasanPulangCepat.value =
                                            null;
                                        controller.resetScanner();
                                        Get.toNamed(Routes.PRESENSI);
                                      }
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              controller.isCheckingToday.value
                                  ? 'Memeriksa status...'
                                  : sedangIzin
                                      ? 'Tidak dapat presensi (Izin)'
                                      : !sudahMasuk
                                          ? 'Belum Masuk'
                                          : sudahPulang
                                              ? 'Sudah Pulang (${controller.jamPulang.value ?? ''})'
                                              : 'Presensi pulang',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMap(Position position) {
    final userLocation = LatLng(position.latitude, position.longitude);
    return FlutterMap(
      options: MapOptions(
        initialCenter: userLocation,
        initialZoom: 17,
      ),
      children: [
        TileLayer(
          urlTemplate: 'http://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: userLocation,
              radius: 45,
              useRadiusInMeter: true,
              color: AppColors.primary.withValues(alpha: 0.16),
              borderColor: AppColors.primary,
              borderStrokeWidth: 2,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: userLocation,
              width: 52,
              height: 52,
              child: const Icon(
                Icons.location_pin,
                color: AppColors.primary,
                size: 48,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationState() {
    final isLoading = controller.isLocationLoading.value;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) const CircularProgressIndicator(),
          if (isLoading) const SizedBox(height: 12),
          Icon(
            isLoading ? Icons.gps_fixed : Icons.location_off,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(controller.locationMessage.value),
          if (!isLoading) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: controller.loadCurrentLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _verificationItem(IconData icon, String text, bool verified) {
    return Row(
      children: [
        Icon(
          icon,
          color: verified ? AppColors.primary : AppColors.textHint,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

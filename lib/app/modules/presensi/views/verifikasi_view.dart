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
                  const Center(
                    child: Text(
                      'Lokasi Anda Terverifikasi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Presensi Masuk button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isAllVerified.value
                            ? () async {
                                final result = await ConfirmationDialog.show(
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
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Presensi masuk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Presensi Pulang button (disabled)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade400,
                        disabledForegroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Presensi pulang',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.moracademy.mobile',
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

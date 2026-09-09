import 'dart:async';

import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/api_service.dart';

class HomeController extends GetxController {
  final user = StorageService.to.getUser().obs;
  final tepatWaktu = 12.obs;
  final terlambat = 1.obs;
  final tidakPresensi = 3.obs;
  final sisaHari = 45.obs;
  final jadwalHariIni = 1.obs;
  final tepatWaktuPercent = 75.obs;
  final notifikasi = 0.obs;
  final currentDateTime = ''.obs;
  Timer? _dateTimeTimer;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _updateDateTime();
    _dateTimeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateDateTime(),
    );
  }

  void _loadUser() {
    user.value = StorageService.to.getUser();

    // Listen ke perubahan session user di StorageService
    ever(StorageService.to.currentUser, (UserModel u) {
      user.value = u;
    });

    // Refresh profile dari backend jika sudah ada token
    if (StorageService.to.isLoggedIn) {
      _refreshProfileFromApi();
    }
  }

  Future<void> _refreshProfileFromApi() async {
    try {
      final response = await ApiService.to.getMe();
      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final data = response.body['data'];
        if (data is Map) {
          final userMap = data['user'] as Map<String, dynamic>?;
          final pesertaMap = data['peserta'] as Map<String, dynamic>?;
          final magangMap = data['magang'] as Map<String, dynamic>?;

          await StorageService.to.saveAuthSession(
            authToken: StorageService.to.token.value,
            user: userMap,
            peserta: pesertaMap,
            magang: magangMap,
          );
        }
      }
    } catch (_) {}
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    currentDateTime.value =
        '$dayName, ${now.day} $monthName ${now.year} - $time';
  }

  @override
  void onClose() {
    _dateTimeTimer?.cancel();
    super.onClose();
  }
}

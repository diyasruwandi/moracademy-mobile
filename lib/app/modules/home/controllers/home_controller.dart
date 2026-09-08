import 'dart:async';

import 'package:get/get.dart';
import '../../../../models/user_model.dart';

class HomeController extends GetxController {
  final user = UserModel.dummy().obs;
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
    _updateDateTime();
    _dateTimeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateDateTime(),
    );
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

import 'dart:ui';
import 'package:get/get.dart';
import '../../../../models/presensi_model.dart';

class RiwayatController extends GetxController {
  final selectedTab = 0.obs; // 0 = Presensi, 1 = Izin
  final selectedMonth = 'Agustus 2026'.obs;
  final presensiList = <PresensiModel>[].obs;
  final izinList = <PresensiModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    presensiList.value = PresensiModel.dummyList();
    izinList.value = PresensiModel.dummyIzinList();
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  String getStatusEmoji(String status) {
    switch (status) {
      case 'tepat_waktu':
        return '😊';
      case 'terlambat':
        return '😐';
      case 'tidak_presensi':
        return '😡';
      case 'izin':
        return '😐';
      default:
        return '😊';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'tepat_waktu':
        return const Color(0xFF2E3192);
      case 'terlambat':
        return const Color(0xFF2E3192);
      case 'tidak_presensi':
        return const Color(0xFFEF4444);
      case 'izin':
        return const Color(0xFF2E3192);
      default:
        return const Color(0xFF2E3192);
    }
  }
}

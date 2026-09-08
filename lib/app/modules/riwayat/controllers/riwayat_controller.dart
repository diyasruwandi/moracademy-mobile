import 'dart:ui';
import 'package:get/get.dart';
import '../../../../models/presensi_model.dart';

class RiwayatController extends GetxController {
  final selectedTab = 0.obs; // 0 = Presensi, 1 = Izin
  final selectedMonth = 'Agustus 2026'.obs;
  final presensiList = <PresensiModel>[].obs;
  final izinList = <PresensiModel>[].obs;
  final monthOptions = [
    'Januari 2026',
    'Februari 2026',
    'Maret 2026',
    'April 2026',
    'Mei 2026',
    'Juni 2026',
    'Juli 2026',
    'Agustus 2026',
    'September 2026',
    'Oktober 2026',
    'November 2026',
    'Desember 2026',
  ];

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

  void selectMonth(String month) {
    selectedMonth.value = month;
  }

  List<PresensiModel> get filteredList {
    final source = selectedTab.value == 0 ? presensiList : izinList;
    return source
        .where((presensi) => presensi.tanggal.contains(selectedMonth.value))
        .toList();
  }

  String getStatusEmoji(PresensiModel presensi) {
    if (presensi.tipe == 'IZIN' || presensi.status == 'izin') {
      return '😐';
    }

    if (presensi.jamMasuk == '--:--' || presensi.status == 'tidak_presensi') {
      return '😢';
    }

    final timeParts = presensi.jamMasuk.split(':');
    if (timeParts.length == 2) {
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour != null && minute != null) {
        final minutesAfterMidnight = hour * 60 + minute;
        return minutesAfterMidnight > (8 * 60) ? '😢' : '😊';
      }
    }

    return '😢';
  }

  String getStatusMood(PresensiModel presensi) {
    if (presensi.tipe == 'IZIN' || presensi.status == 'izin') {
      return 'neutral';
    }

    if (presensi.jamMasuk == '--:--' || presensi.status == 'tidak_presensi') {
      return 'sad';
    }

    final timeParts = presensi.jamMasuk.split(':');
    if (timeParts.length == 2) {
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour != null && minute != null) {
        return hour * 60 + minute > (8 * 60) ? 'sad' : 'happy';
      }
    }

    return 'sad';
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

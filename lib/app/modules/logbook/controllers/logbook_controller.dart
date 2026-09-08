import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/logbook_model.dart';

class LogbookController extends GetxController {
  final selectedFilter = 0.obs; // 0=Minggu Ini, 1=Bulan Ini, 2=Custom
  final logbookList = <LogbookModel>[].obs;
  final customDateRange = Rxn<DateTimeRange>();
  final isLoading = false.obs;

  // Entry form
  final tanggalKegiatan = Rxn<DateTime>();
  final kategoriKegiatan = 'Software Development'.obs;
  final judulController = TextEditingController();
  final detailController = TextEditingController();

  final kategoriOptions = [
    'Software Development',
    'DevOps',
    'QA Testing',
    'UI/UX Design',
    'Data Analysis',
    'Lainnya',
  ];

  @override
  void onInit() {
    super.onInit();
    loadLogbook();
  }

  void loadLogbook() {
    logbookList.value = LogbookModel.dummyList();
  }

  void switchFilter(int index) {
    selectedFilter.value = index;
  }

  List<LogbookModel> get filteredLogbookList {
    final range = customDateRange.value;
    if (selectedFilter.value != 2 || range == null) {
      return logbookList.toList();
    }

    final start =
        DateTime(range.start.year, range.start.month, range.start.day);
    final end =
        DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);

    return logbookList.where((logbook) {
      final date = _parseLogbookDate(logbook.tanggal);
      return date != null && !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  Future<void> selectCustomDateRange(BuildContext context) async {
    final now = DateTime.now();
    final currentRange = customDateRange.value;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: currentRange,
      currentDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF2E3192),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      customDateRange.value = picked;
      selectedFilter.value = 2;
    }
  }

  String get customDateRangeLabel {
    final range = customDateRange.value;
    if (range == null) return 'Custom Range';
    return '${_formatShortDate(range.start)} - ${_formatShortDate(range.end)}';
  }

  DateTime? _parseLogbookDate(String value) {
    final match =
        RegExp(r'(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})').firstMatch(value);
    if (match == null) return null;

    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    final month = months[match.group(2)];
    if (month == null) return null;

    return DateTime(
      int.parse(match.group(3)!),
      month,
      int.parse(match.group(1)!),
    );
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      tanggalKegiatan.value = picked;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Hari ini, ${_formatFullDate(DateTime.now())}';
    return _formatFullDate(date);
  }

  String _formatFullDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void simpanLogbook() {
    if (judulController.text.isEmpty || detailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Judul dan detail kegiatan harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Logbook berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  @override
  void onClose() {
    judulController.dispose();
    detailController.dispose();
    super.onClose();
  }
}

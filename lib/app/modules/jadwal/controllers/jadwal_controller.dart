import 'package:get/get.dart';
import '../../../../models/jadwal_model.dart';

class JadwalController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final currentMonth = DateTime.now().obs;
  final jadwalList = <JadwalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in selectedDate and update jadwalList automatically
    ever(selectedDate, (_) => _generateJadwalForSelectedDate());
    _generateJadwalForSelectedDate();
  }

  void _generateJadwalForSelectedDate() {
    final date = selectedDate.value;
    
    // Libur jika Sabtu (6), Minggu (7), atau tanggal merah
    if (date.weekday == 6 || date.weekday == 7 || isTanggalMerah(date)) {
      jadwalList.clear();
      return;
    }

    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final formattedDate = '${date.day} ${months[date.month - 1]} ${date.year}';

    // Jadwal magang: 08:00 hingga 16:00
    jadwalList.value = [
      JadwalModel(
        tanggal: formattedDate,
        jamMasuk: '08:00',
        jamPulang: '16:00',
        tipe: 'WFO',
      )
    ];
  }

  bool isTanggalMerah(DateTime date) {
    // Sebagai contoh statis beberapa hari libur nasional 2026
    // Nantinya bisa menggunakan API libur nasional
    final liburNasional = [
      '2026-01-01', // Tahun Baru Masehi
      '2026-02-17', // Isra Mikraj
      '2026-03-20', // Hari Raya Nyepi
      '2026-03-20', // Idul Fitri (estimasi)
      '2026-05-01', // Hari Buruh
      '2026-05-14', // Kenaikan Isa Almasih
      '2026-05-26', // Idul Adha (estimasi)
      '2026-08-17', // Hari Kemerdekaan RI
      '2026-12-25', // Hari Raya Natal
    ];
    final formatted = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return liburNasional.contains(formatted);
  }


  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
  }

  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isSelected(DateTime date) {
    return date.year == selectedDate.value.year &&
        date.month == selectedDate.value.month &&
        date.day == selectedDate.value.day;
  }
}

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
    
    // Jika hari Minggu (7), anggap libur
    if (date.weekday == 7) {
      jadwalList.clear();
      return;
    }

    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final formattedDate = '${date.day} ${months[date.month - 1]} ${date.year}';

    // Jika hari Sabtu (6), jadwal bisa berbeda misal setengah hari, atau disamakan dengan hari biasa
    // Di sini kita samakan dengan hari biasa sebagai contoh (08:00 - 17:00)
    jadwalList.value = [
      JadwalModel(
        tanggal: formattedDate,
        jamMasuk: '08:00',
        jamPulang: date.weekday == 6 ? '14:00' : '17:00', // Sabtu pulang lebih cepat sebagai contoh
        tipe: 'WFO',
      )
    ];
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

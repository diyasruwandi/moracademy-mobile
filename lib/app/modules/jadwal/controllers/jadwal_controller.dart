import 'package:get/get.dart';
import '../../../../models/jadwal_model.dart';

class JadwalController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final currentMonth = DateTime.now().obs;
  final jadwalList = <JadwalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadJadwal();
  }

  void loadJadwal() {
    jadwalList.value = [JadwalModel.dummy()];
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

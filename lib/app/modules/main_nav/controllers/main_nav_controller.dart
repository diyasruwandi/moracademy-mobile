import 'package:get/get.dart';

class MainNavController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    if (index == 1) {
      // Center QR button - navigate to presensi
      Get.toNamed('/presensi');
      return;
    }
    currentIndex.value = index > 1 ? index - 1 : index;
  }
}

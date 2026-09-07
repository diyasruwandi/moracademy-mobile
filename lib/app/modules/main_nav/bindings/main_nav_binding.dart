import 'package:get/get.dart';
import '../controllers/main_nav_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../riwayat/controllers/riwayat_controller.dart';
import '../../logbook/controllers/logbook_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RiwayatController>(() => RiwayatController());
    Get.lazyPut<LogbookController>(() => LogbookController());
  }
}

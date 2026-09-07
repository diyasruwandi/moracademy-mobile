import 'package:get/get.dart';
import '../controllers/logbook_controller.dart';

class LogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookController>(() => LogbookController());
  }
}

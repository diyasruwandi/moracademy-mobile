import 'package:get/get.dart';
import '../../../../models/tugas_model.dart';

class TugasController extends GetxController {
  final tugasList = <TugasModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTugas();
  }

  void loadTugas() {
    tugasList.value = TugasModel.dummyList();
  }
}

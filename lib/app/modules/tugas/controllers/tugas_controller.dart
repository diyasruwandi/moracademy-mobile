import 'package:get/get.dart';
import '../../../../models/tugas_model.dart';
import '../../../../core/services/api_service.dart';

class TugasController extends GetxController {
  final tugasList = <TugasModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTugas();
  }

  Future<void> loadTugas() async {
    try {
      isLoading.value = true;
      final response = await ApiService.to.getTugas();
      
      if (response.isOk && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        tugasList.value = data.map((json) => TugasModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Gagal', ApiService.getErrorMessage(response));
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

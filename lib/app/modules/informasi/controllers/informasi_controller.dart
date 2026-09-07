import 'package:get/get.dart';

class InformasiController extends GetxController {
  final searchController = ''.obs;
  final isLoading = false.obs;

  void search(String query) {
    searchController.value = query;
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }
}

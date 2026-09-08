import 'package:get/get.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/api_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    if (StorageService.to.isLoggedIn) {
      // Validasi token di background
      _validateSession();
      // Langsung masuk ke Dashboard
      Get.offAllNamed(Routes.MAIN_NAV);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> _validateSession() async {
    try {
      final response = await ApiService.to.getMe();
      if (!response.isOk || (response.body is Map && response.body['success'] != true)) {
        // Jika token revoked atau kedaluwarsa, logout otomatis
        await StorageService.to.clearSession();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (_) {}
  }
}

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    final prefs = await SharedPreferences.getInstance();
    final directToken = prefs.getString('auth_token') ?? '';

    print("========================================");
    print("🔍 [SPLASH] Memeriksa status login...");
    print(
        "🔍 [SPLASH] Token di StorageService: '${StorageService.to.token.value}'");
    print("🔍 [SPLASH] Token asli dari Disk: '$directToken'");
    print("🔍 [SPLASH] IsLoggedIn: ${StorageService.to.isLoggedIn}");
    print("========================================");

    if (directToken.isNotEmpty) {
      if (StorageService.to.token.value.isEmpty) {
        StorageService.to.token.value = directToken;
      }
      _validateSession();
      Get.offAllNamed(Routes.MAIN_NAV);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> _validateSession() async {
    try {
      final response = await ApiService.to.getMe();
      if (response.status.isUnauthorized ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        print(
            "🔴 [SPLASH] Token tidak valid atau kedaluwarsa. Status Code: ${response.statusCode}");
        print("🔴 [SPLASH] Body: ${response.body}");
        // Hanya logout otomatis jika token terbukti revoked/kedaluwarsa (401/403)
        await StorageService.to.clearSession();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        print(
            "✅ [SPLASH] Sesi masih valid. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("🔴 [SPLASH] Error validasi: $e");
    }
  }
}

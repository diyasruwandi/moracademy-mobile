import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../routes/app_pages.dart';

class ProfilController extends GetxController {
  final user = StorageService.to.getUser().obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    user.value = StorageService.to.getUser();

    // Listen ke perubahan session user
    ever(StorageService.to.currentUser, (UserModel u) {
      user.value = u;
    });

    if (StorageService.to.isLoggedIn) {
      refreshProfile();
    }
  }

  Future<void> refreshProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getMe();
      isLoading.value = false;

      if (response.isOk && response.body is Map && response.body['success'] == true) {
        final data = response.body['data'];
        if (data is Map) {
          final userMap = data['user'] as Map<String, dynamic>?;
          final pesertaMap = data['peserta'] as Map<String, dynamic>?;
          final magangMap = data['magang'] as Map<String, dynamic>?;

          await StorageService.to.saveAuthSession(
            authToken: StorageService.to.token.value,
            user: userMap,
            peserta: pesertaMap,
            magang: magangMap,
          );
        }
      }
    } catch (_) {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.to.logout();
    } catch (_) {}
    StorageService.to.clearSession();
    Get.offAllNamed(Routes.LOGIN);
  }
}

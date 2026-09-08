import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class StorageService extends GetxService {
  static StorageService get to {
    if (!Get.isRegistered<StorageService>()) {
      final service = StorageService();
      Get.put(service, permanent: true);
      service._initPrefs();
      return service;
    }
    return Get.find<StorageService>();
  }

  SharedPreferences? _prefs;

  final token = ''.obs;
  final userData = Rxn<Map<String, dynamic>>();
  final pesertaData = Rxn<Map<String, dynamic>>();
  final magangData = Rxn<Map<String, dynamic>>();
  final currentUser = UserModel.dummy().obs;

  bool get isLoggedIn => token.value.isNotEmpty;

  static Future<StorageService> init() async {
    final service = StorageService();
    await service._initPrefs();
    return Get.put(service, permanent: true);
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadStoredData();
  }

  void _loadStoredData() {
    if (_prefs == null) return;
    final savedToken = _prefs?.getString('auth_token') ?? '';
    token.value = savedToken;

    final userString = _prefs?.getString('user_data');
    final pesertaString = _prefs?.getString('peserta_data');
    final magangString = _prefs?.getString('magang_data');

    if (userString != null) {
      try {
        userData.value = jsonDecode(userString) as Map<String, dynamic>;
      } catch (_) {}
    }

    if (pesertaString != null) {
      try {
        pesertaData.value = jsonDecode(pesertaString) as Map<String, dynamic>;
      } catch (_) {}
    }

    if (magangString != null) {
      try {
        magangData.value = jsonDecode(magangString) as Map<String, dynamic>;
      } catch (_) {}
    }

    if (savedToken.isNotEmpty) {
      final combinedMap = {
        'user': userData.value,
        'peserta': pesertaData.value,
        'magang': magangData.value,
      };
      currentUser.value = UserModel.fromJson(combinedMap);
    }
  }

  Future<void> saveAuthSession({
    required String authToken,
    Map<String, dynamic>? user,
    Map<String, dynamic>? peserta,
    Map<String, dynamic>? magang,
  }) async {
    token.value = authToken;
    userData.value = user;
    pesertaData.value = peserta;
    magangData.value = magang;

    final combinedMap = {
      'user': user,
      'peserta': peserta,
      'magang': magang,
    };
    currentUser.value = UserModel.fromJson(combinedMap);

    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString('auth_token', authToken);
    if (user != null) {
      await _prefs?.setString('user_data', jsonEncode(user));
    }
    if (peserta != null) {
      await _prefs?.setString('peserta_data', jsonEncode(peserta));
    }
    if (magang != null) {
      await _prefs?.setString('magang_data', jsonEncode(magang));
    }
  }

  UserModel getUser() {
    return currentUser.value;
  }

  Future<void> clearSession() async {
    token.value = '';
    userData.value = null;
    pesertaData.value = null;
    magangData.value = null;
    currentUser.value = UserModel.dummy();

    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.remove('auth_token');
    await _prefs?.remove('user_data');
    await _prefs?.remove('peserta_data');
    await _prefs?.remove('magang_data');
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // URL Publik Ngrok / Server Domain
  // Masukkan URL Ngrok Anda di sini (jangan lupa akhiri dengan /api/v1)
  static const String customBaseUrl =
      'https://june-chattable-tora.ngrok-free.dev/api/v1';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://127.0.0.1:8000/api/v1';
  }

  // Auth Endpoints
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
}

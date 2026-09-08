import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // =========================================================================
  // URL Backend UTAMA (moracademy) — untuk Auth, Profil, dll
  // =========================================================================
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

  // =========================================================================
  // URL Backend QR (qr_moracademy) — untuk Presensi Scan & Check
  // =========================================================================
  static const String customQrBaseUrl = '';

  static String get qrBaseUrl {
    if (customQrBaseUrl.isNotEmpty) {
      return customQrBaseUrl;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8001';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8001';
    }
    return 'http://127.0.0.1:8001';
  }

  // Auth Endpoints (moracademy)
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // Presensi Endpoints (qr_moracademy — via routes/api.php, otomatis prefix /api)
  static const String presensiScan = '/api/presensi/scan';
  static const String presensiCheckToday = '/api/presensi/check-today';
}

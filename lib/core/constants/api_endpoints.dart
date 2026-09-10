import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // =========================================================================
  // URL Backend UTAMA (moracademy) — untuk Auth, Profil, dll
  // =========================================================================
  // Kosongkan string ( '' ) jika ingin menggunakan IP lokal di bawah

  static const String customBaseUrl =
      'https://june-chattable-tora.ngrok-free.dev/api/v1';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }
    if (kIsWeb) {

      return 'http://192.168.18.175:8000/api/v1';
    }
    if (Platform.isAndroid) {
      return 'http://192.168.18.175:8000/api/v1';
    }
    return 'http://192.168.18.175:8000/api/v1';
  }

  // URL Server QR Presensi (qr_moracademy - Port 8001)
  // Anda bisa memasukkan URL Ngrok Port 8001 atau IP lokal Wi-Fi (misal 'http://192.168.1.10:8001/api')
  // Kosongkan string ( '' ) jika ingin menggunakan IP lokal di bawah
  static const String customQrBaseUrl =
      'https://pretext-update-hatchling.ngrok-free.dev/api';

  static String get qrBaseUrl {
    if (customQrBaseUrl.isNotEmpty) {
      return customQrBaseUrl;
    }
    if (kIsWeb) {

      return 'http://192.168.18.175:8001/api';
    }
    if (Platform.isAndroid) {
      return 'http://192.168.18.175:8001/api';
    }
    return 'http://192.168.18.175:8001/api';
  }

  // Auth Endpoints (Port 8000 / Backend Utama)
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  static const String riwayatPresensi = '/auth/presensi/riwayat';
  static const String tugas = '/tugas';

  // Presensi Endpoints (Port 8001 / QR Moracademy)
  static const String presensiScan = '/presensi/scan';
  static const String presensiCheckToday = '/presensi/check-today';

  // Logbook Endpoints (Port 8000 / Backend Utama)
  static const String logbook = '/logbook';
}
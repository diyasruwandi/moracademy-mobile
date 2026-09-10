import 'dart:io';
import 'package:get/get.dart';
import '../constants/api_endpoints.dart';
import 'storage_service.dart';

class ApiService extends GetConnect implements GetxService {
  static ApiService get to {
    if (!Get.isRegistered<ApiService>()) {
      return Get.put(ApiService(), permanent: true);
    }
    return Get.find<ApiService>();
  }

  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    httpClient.timeout = const Duration(
        seconds:
            60); // Diperpanjang agar tidak timeout jika koneksi email lambat

    // Request Modifier (menambahkan header default dan Bearer token jika ada)
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      // Hapus baris Content-Type agar GetConnect otomatis mengatur multipart/form-data untuk FormData
      request.headers['ngrok-skip-browser-warning'] = 'true';

      if (Get.isRegistered<StorageService>() && StorageService.to.isLoggedIn) {
        request.headers['Authorization'] =
            'Bearer ${StorageService.to.token.value}';
      }
      return request;
    });

    super.onInit();
  }

  // =========================================================================
  // AUTH ENDPOINTS (moracademy)
  // =========================================================================

  /// Request OTP 6 digit ke email peserta magang
  Future<Response> requestOtp(String email) async {
    return await post(
      ApiEndpoints.requestOtp,
      {
        'email': email,
      },
      contentType: 'application/json',
    );
  }

  /// Verifikasi OTP 6 digit dan dapatkan token Sanctum
  Future<Response> verifyOtp(String email, String otp) async {
    return await post(
      ApiEndpoints.verifyOtp,
      {
        'email': email,
        'otp': otp,
      },
      contentType: 'application/json',
    );
  }

  /// Ambil profil akun magang aktif
  Future<Response> getMe() async {
    return await get(ApiEndpoints.me);
  }

  /// Logout akun dan revoke token
  Future<Response> logout() async {
    return await post(ApiEndpoints.logout, {});
  }

  /// Ambil riwayat presensi user (dari moracademy backend)
  Future<Response> getRiwayatPresensi() async {
    return await get(ApiEndpoints.riwayatPresensi);
  }

  /// Ambil daftar tugas user
  Future<Response> getTugas() async {
    return await get(ApiEndpoints.tugas);
  }

  /// Tambah tugas baru (mendukung upload file_lampiran)
  Future<Response> addTugas(FormData data) async {
    return await post(ApiEndpoints.tugas, data);
  }

  /// Scan QR Code Presensi (dikirim ke QR Moracademy / Port 8001)
  Future<Response> scanPresensi({
    required String qrToken,
    required double latitude,
    required double longitude,
  }) async {
    final url = '${ApiEndpoints.qrBaseUrl}${ApiEndpoints.presensiScan}';
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    if (Get.isRegistered<StorageService>() && StorageService.to.isLoggedIn) {
      headers['Authorization'] = 'Bearer ${StorageService.to.token.value}';
    }
    final qrClient = GetConnect(timeout: const Duration(seconds: 60));
    return await qrClient.post(
      url,
      {
        'qr_token': qrToken,
        'latitude': latitude,
        'longitude': longitude,
      },
      headers: headers,
    );
  }

  /// Cek status presensi hari ini (dikirim ke QR Moracademy / Port 8001)
  Future<Response> checkTodayPresensi() async {
    final url = '${ApiEndpoints.qrBaseUrl}${ApiEndpoints.presensiCheckToday}';
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    if (Get.isRegistered<StorageService>() && StorageService.to.isLoggedIn) {
      headers['Authorization'] = 'Bearer ${StorageService.to.token.value}';
    }
    final qrClient = GetConnect(timeout: const Duration(seconds: 60));
    return await qrClient.get(url, headers: headers);
  }

  // =========================================================================
  // LOGBOOK ENDPOINTS (moracademy)
  // =========================================================================

  /// Mengambil daftar riwayat logbook milik peserta
  Future<Response> getLogbooks({
    String? filter,
    String? startDate,
    String? endDate,
    String? tanggal,
  }) async {
    final query = <String, String>{};
    if (filter != null && filter.isNotEmpty) query['filter'] = filter;
    if (startDate != null && startDate.isNotEmpty) query['start_date'] = startDate;
    if (endDate != null && endDate.isNotEmpty) query['end_date'] = endDate;
    if (tanggal != null && tanggal.isNotEmpty) query['tanggal'] = tanggal;

    return await get(
      ApiEndpoints.logbook,
      query: query.isNotEmpty ? query : null,
    );
  }

  /// Simpan catatan logbook baru ke backend
  Future<Response> createLogbook({
    required String tanggal,
    required String kategori,
    required String judul,
    required String detail,
    String? lampiranPath,
  }) async {
    if (lampiranPath != null && lampiranPath.isNotEmpty) {
      final file = File(lampiranPath);
      final filename = lampiranPath.split(Platform.pathSeparator).last;
      final form = FormData({
        'tanggal': tanggal,
        'kategori': kategori,
        'judul': judul,
        'detail': detail,
        'lampiran': MultipartFile(file, filename: filename),
      });
      return await post(ApiEndpoints.logbook, form);
    } else {
      return await post(
        ApiEndpoints.logbook,
        {
          'tanggal': tanggal,
          'kategori': kategori,
          'judul': judul,
          'detail': detail,
        },
        contentType: 'application/json',
      );
    }
  }

  /// Hapus catatan logbook
  Future<Response> deleteLogbook(String id) async {
    return await delete('${ApiEndpoints.logbook}/$id');
  }

  /// Helper untuk mengambil pesan error dari response backend
  static String getErrorMessage(Response response) {
    if (response.status.connectionError) {
      return 'Gagal terhubung ke server. Pastikan server backend Laravel sedang aktif.';
    }

    if (response.body is Map && response.body['message'] != null) {
      return response.body['message'].toString();
    }

    switch (response.statusCode) {
      case 400:
        return 'Permintaan tidak valid atau data tidak sesuai.';
      case 403:
        return 'Akses ditolak. Akun Anda tidak memiliki izin.';
      case 404:
        return 'Data atau akun tidak ditemukan.';
      case 422:
        return 'Data yang dikirimkan tidak valid.';
      case 429:
        return 'Terlalu banyak permintaan. Silakan tunggu beberapa saat.';
      case 500:
        return 'Terjadi kesalahan pada server backend.';
      default:
        return 'Terjadi kesalahan tidak terduga (${response.statusCode ?? 'unknown'}).';
    }
  }
}

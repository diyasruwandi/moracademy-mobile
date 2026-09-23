import 'dart:io';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/api_endpoints.dart';
import 'storage_service.dart';

class ApiService extends GetConnect implements GetxService {
  static ApiService get to {
    if (!Get.isRegistered<ApiService>()) {
      return Get.put(ApiService(), permanent: true);
    }
    return Get.find<ApiService>();
  }

  // Client khusus untuk upload file agar tidak terkena bug modifier GetConnect pada FormData
  final GetConnect _uploadClient = GetConnect();

  Future<Map<String, String>> get _authHeaders async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    if (Get.isRegistered<StorageService>() && StorageService.to.isLoggedIn) {
      headers['Authorization'] = 'Bearer ${StorageService.to.token.value}';
    }

    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        headers['X-Latitude'] = position.latitude.toString();
        headers['X-Longitude'] = position.longitude.toString();
      }
    } catch (_) {}

    return headers;
  }

  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);

    _uploadClient.baseUrl = ApiEndpoints.baseUrl;
    _uploadClient.timeout = const Duration(seconds: 60);

    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['Accept'] = 'application/json';
      request.headers['ngrok-skip-browser-warning'] = 'true';

      if (Get.isRegistered<StorageService>() && StorageService.to.isLoggedIn) {
        request.headers['Authorization'] =
            'Bearer ${StorageService.to.token.value}';
      }

      try {
        final position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          request.headers['X-Latitude'] = position.latitude.toString();
          request.headers['X-Longitude'] = position.longitude.toString();
        }
      } catch (e) {
        // Abaikan jika GPS tidak aktif/tidak ada izin
      }

      return request
          as dynamic; // Cast to ensure it matches FutureOr<Request<dynamic>>
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
  Future<Response> addTugas(dynamic data) async {
    return await _uploadClient.post(ApiEndpoints.tugas, data,
        headers: await _authHeaders);
  }

  /// Memperbarui tugas yang sudah ada
  Future<Response> editTugas(String id, dynamic data) async {
    return await _uploadClient.post('${ApiEndpoints.tugas}/update/$id', data,
        headers: await _authHeaders);
  }

  /// Scan QR Code Presensi (dikirim ke QR Moracademy / Port 8001)
  Future<Response> scanPresensi({
    required String qrToken,
    required double latitude,
    required double longitude,
    String? alasanPulang,
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

    headers['X-Latitude'] = latitude.toString();
    headers['X-Longitude'] = longitude.toString();

    final payload = <String, dynamic>{
      'qr_token': qrToken,
      'latitude': latitude,
      'longitude': longitude,
    };

    if (alasanPulang != null && alasanPulang.trim().isNotEmpty) {
      payload['alasan_pulang'] = alasanPulang.trim();
    }

    final qrClient = GetConnect(timeout: const Duration(seconds: 60));
    return await qrClient.post(
      url,
      payload,
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

    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        headers['X-Latitude'] = position.latitude.toString();
        headers['X-Longitude'] = position.longitude.toString();
      }
    } catch (_) {}
    final qrClient = GetConnect(timeout: const Duration(seconds: 60));
    return await qrClient.get(url, headers: headers);
  }

  /// Mengajukan izin (Sakit, Izin Pribadi, dll)
  Future<Response> ajukanIzin(FormData data) async {
    return await _uploadClient.post(ApiEndpoints.presensiIzin, data,
        headers: await _authHeaders);
  }

  /// Mengambil riwayat presensi (bulanan) dari backend utama
  Future<Response> getPresensiHistory(int month, int year) async {
    return await get('${ApiEndpoints.presensiHistory}?month=$month&year=$year');
  }

  // =========================================================================
  // INFORMASI MAGANG ENDPOINTS (moracademy)
  // =========================================================================

  Future<Response> getInformasiMagang() async {
    return await get(ApiEndpoints.informasiMagang);
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
    if (startDate != null && startDate.isNotEmpty)
      query['start_date'] = startDate;
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
      final bytes = file.readAsBytesSync();
      final form = FormData({
        'tanggal': tanggal,
        'kategori': kategori,
        'judul': judul,
        'detail': detail,
        'lampiran': MultipartFile(bytes, filename: filename),
      });
      return await _uploadClient.post(ApiEndpoints.logbook, form,
          headers: await _authHeaders);
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

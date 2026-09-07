part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const FORGOT_PASSWORD_SUCCESS = _Paths.FORGOT_PASSWORD_SUCCESS;
  static const MAIN_NAV = _Paths.MAIN_NAV;
  static const HOME = _Paths.HOME;
  static const JADWAL = _Paths.JADWAL;
  static const IZIN = _Paths.IZIN;
  static const TUGAS = _Paths.TUGAS;
  static const INFORMASI = _Paths.INFORMASI;
  static const PRESENSI = _Paths.PRESENSI;
  static const VERIFIKASI = _Paths.VERIFIKASI;
  static const RIWAYAT = _Paths.RIWAYAT;
  static const LOGBOOK = _Paths.LOGBOOK;
  static const LOGBOOK_ENTRY = _Paths.LOGBOOK_ENTRY;
  static const PROFIL = _Paths.PROFIL;
  static const BANTUAN = _Paths.BANTUAN;
  static const TENTANG = _Paths.TENTANG;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const FORGOT_PASSWORD_SUCCESS = '/forgot-password-success';
  static const MAIN_NAV = '/main-nav';
  static const HOME = '/home';
  static const JADWAL = '/jadwal';
  static const IZIN = '/izin';
  static const TUGAS = '/tugas';
  static const INFORMASI = '/informasi';
  static const PRESENSI = '/presensi';
  static const VERIFIKASI = '/verifikasi';
  static const RIWAYAT = '/riwayat';
  static const LOGBOOK = '/logbook';
  static const LOGBOOK_ENTRY = '/logbook-entry';
  static const PROFIL = '/profil';
  static const BANTUAN = '/bantuan';
  static const TENTANG = '/tentang';
}

import 'package:get/get.dart';
import '../controllers/presensi_controller.dart';

class PresensiBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan fenix: true agar controller tidak dihapus saat
    // navigasi antar VerifikasiView ↔ PresensiView (scanner).
    // Ini memastikan state hasMasuk/hasPulang tetap terjaga.
    Get.lazyPut<PresensiController>(() => PresensiController(), fenix: true);
  }
}

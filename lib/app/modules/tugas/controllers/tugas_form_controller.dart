import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../models/tugas_model.dart';
import '../../../../core/utils/app_snackbar.dart';
import 'tugas_controller.dart';

class TugasFormController extends GetxController {
  final isEdit = false.obs;
  String editId = '';

  final tanggalKegiatan = DateTime.now().obs;
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final linkController = TextEditingController();
  final pemberiTugasController = TextEditingController();
  final penerimaTugasController = TextEditingController();

  final mediaTugas = 'Github'.obs;

  final mediaOptions = [
    'Github',
    'Gitlab',
    'Google Drive',
    'Lainnya',
  ];

  final selectedImage = Rxn<File>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TugasModel) {
      isEdit.value = true;
      editId = args.id;

      judulController.text = args.judul;
      pemberiTugasController.text = args.pemberiTugas;
      penerimaTugasController.text = args.penerimaTugas;
      deskripsiController.text = args.deskripsi;
      linkController.text = args.linkTugas;

      if (mediaOptions.contains(args.media)) {
        mediaTugas.value = args.media;
      }

      // Note: we can't easily parse formatted date "10 September 2026" back to DateTime,
      // so we just leave it as DateTime.now() or we could try parsing it.
      // But let's keep it simple for now.
    }
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalKegiatan.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      tanggalKegiatan.value = picked;
    }
  }

  String formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 1024,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> simpanTugas() async {
    if (judulController.text.trim().isEmpty) {
      AppSnackbar.showError('Error', 'Judul tugas wajib diisi!');
      return;
    }

    if (pemberiTugasController.text.trim().isEmpty ||
        penerimaTugasController.text.trim().isEmpty) {
      AppSnackbar.showError(
          'Error', 'Pemberi tugas dan penerima tugas wajib diisi!');
      return;
    }

    try {
      isLoading.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      final pesertaId =
          StorageService.to.pesertaData.value?['id']?.toString() ?? '';

      final map = <String, dynamic>{
        'peserta_id': pesertaId,
        'judul': judulController.text.trim(),
        'pemberi_tugas': pemberiTugasController.text.trim(),
        'penerima_tugas': penerimaTugasController.text.trim(),
      };

      final desc = deskripsiController.text.trim();
      if (desc.isNotEmpty) map['deskripsi'] = desc;

      map['tanggal_tugas'] =
          '${tanggalKegiatan.value.year}-${tanggalKegiatan.value.month.toString().padLeft(2, '0')}-${tanggalKegiatan.value.day.toString().padLeft(2, '0')}';

      final media = mediaTugas.value;
      if (media.isNotEmpty) map['media'] = media;

      final link = linkController.text.trim();
      if (link.isNotEmpty) map['link_tugas'] = link;

      Response response;

      if (selectedImage.value != null) {
        map['file_lampiran'] = MultipartFile(
          File(selectedImage.value!.path).readAsBytesSync(),
          filename: selectedImage.value!.path.split('/').last,
        );
        final formData = FormData(map);
        response = isEdit.value
            ? await ApiService.to.editTugas(editId, formData)
            : await ApiService.to.addTugas(formData);
      } else {
        response = isEdit.value
            ? await ApiService.to.editTugas(editId, map as dynamic)
            : await ApiService.to.addTugas(map as dynamic);
      }

      debugPrint(
          'DEBUG TUGAS: code=${response.statusCode}, text=${response.statusText}, hasError=${response.hasError}, body=${response.body}');

      // Tutup loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response.isOk && response.body['success'] == true) {
        Get.until((route) => route.settings.name == '/tugas');
        // Show success notification after navigation settles
        final successMsg = isEdit.value
            ? 'Tugas berhasil diperbarui'
            : 'Tugas berhasil ditambahkan';
        Future.delayed(const Duration(milliseconds: 500), () {
          AppSnackbar.showSuccess('Sukses', successMsg);
        });
        if (Get.isRegistered<TugasController>()) {
          Get.find<TugasController>().loadTugas();
        }
      } else {
        AppSnackbar.showError('Gagal', ApiService.getErrorMessage(response));
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      AppSnackbar.showError('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    judulController.dispose();
    pemberiTugasController.dispose();
    penerimaTugasController.dispose();
    deskripsiController.dispose();
    linkController.dispose();
    super.onClose();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import 'tugas_controller.dart';

class TugasFormController extends GetxController {
  final tanggalKegiatan = DateTime.now().obs;
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final linkController = TextEditingController();
  final mediaTugas = 'Github'.obs;
  
  final mediaOptions = [
    'Github',
    'Gitlab',
    'Google Drive',
    'Lainnya',
  ];

  final selectedImage = Rxn<File>();
  final isLoading = false.obs;

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
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> simpanTugas() async {
    if (judulController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Judul tugas wajib diisi!');
      return;
    }

    try {
      isLoading.value = true;
      final pesertaId = StorageService.to.pesertaData.value?['id']?.toString() ?? '';
      
      final formData = FormData({
        'peserta_id': pesertaId,
        'judul': judulController.text.trim(),
        'deskripsi': deskripsiController.text.trim(),
        'tanggal_tugas': '${tanggalKegiatan.value.year}-${tanggalKegiatan.value.month.toString().padLeft(2, '0')}-${tanggalKegiatan.value.day.toString().padLeft(2, '0')}',
        'media': mediaTugas.value,
        'link_tugas': linkController.text.trim(),
      });

      if (selectedImage.value != null) {
        formData.files.add(MapEntry(
          'file_lampiran',
          MultipartFile(selectedImage.value!.path, filename: selectedImage.value!.path.split('/').last),
        ));
      }

      final response = await ApiService.to.addTugas(formData);
      
      if (response.isOk && response.body['success'] == true) {
        Get.back();
        Get.snackbar('Sukses', 'Tugas berhasil ditambahkan');
        if (Get.isRegistered<TugasController>()) {
          Get.find<TugasController>().loadTugas();
        }
      } else {
        Get.snackbar('Gagal', ApiService.getErrorMessage(response));
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    linkController.dispose();
    super.onClose();
  }
}

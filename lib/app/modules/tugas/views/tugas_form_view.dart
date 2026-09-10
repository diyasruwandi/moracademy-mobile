import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controllers/tugas_form_controller.dart';

class TugasFormView extends StatelessWidget {
  const TugasFormView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller manually when this page is pushed
    final controller = Get.put(TugasFormController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: controller.isEdit.value ? 'Edit Tugas' : 'Tambah Tugas',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal Tugas
            const Text(
              'Tanggal Tugas',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => controller.pickDate(context),
              child: Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Text(
                        controller.formatDate(controller.tanggalKegiatan.value),
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul Kegiatan
            const Text(
              'Judul Tugas',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.judulController,
              decoration: _inputDecoration('misal: Membuat API Login'),
            ),
            const SizedBox(height: 20),

            // Pemberi Tugas
            const Text(
              'Tugas Dari Siapa',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.pemberiTugasController,
              decoration: _inputDecoration('misal: Bapak Budi (Mentor)'),
            ),
            const SizedBox(height: 20),

            // Penerima Tugas
            const Text(
              'Tugas Ke Siapa',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.penerimaTugasController,
              decoration: _inputDecoration('misal: Tim Frontend'),
            ),
            const SizedBox(height: 20),

            // Media
            const Text(
              'Media Tugas',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.mediaTugas.value,
                    items: controller.mediaOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) controller.mediaTugas.value = v;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Link Tugas
            const Text(
              'Link Tugas (Opsional)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.linkController,
              decoration: _inputDecoration('misal: https://github.com/user/repo'),
            ),
            const SizedBox(height: 20),

            // Deskripsi
            const Text(
              'Deskripsi / Catatan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.deskripsiController,
              maxLines: 4,
              decoration: _inputDecoration('Jelaskan detail pengerjaan tugas...'),
            ),
            const SizedBox(height: 20),

            // Lampiran
            const Text(
              'Lampiran Bukti (Opsional)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => controller.pickImage(),
              child: Obx(() {
                if (controller.selectedImage.value != null) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      image: DecorationImage(
                        image: FileImage(controller.selectedImage.value!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt_outlined, color: AppColors.textHint, size: 32),
                      const SizedBox(height: 8),
                      const Text(
                        'Unggah Bukti / Screenshot',
                        style: TextStyle(color: AppColors.textHint, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Submit button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          final result = await ConfirmationDialog.show(
                            context,
                            message: 'Apakah Anda yakin ingin mengirim tugas ini?',
                          );
                          if (result == true) {
                            controller.simpanTugas();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Kirim Tugas',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

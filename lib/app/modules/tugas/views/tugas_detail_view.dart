import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/tugas_controller.dart';
import '../../../../models/tugas_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TugasDetailView extends GetView<TugasController> {
  const TugasDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final TugasModel tugas = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Tugas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badges
              Row(
                children: [
                  _badge(tugas.tanggalTugas, AppColors.primary.withValues(alpha: 0.1), AppColors.primary),
                  const SizedBox(width: 8),
                  if (tugas.media.isNotEmpty)
                    _badge(tugas.media, const Color(0xFFFFF3E0), const Color(0xFFE65100)),
                ],
              ),
              const SizedBox(height: 16),
              // Judul
              Text(
                tugas.judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Deskripsi
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tugas.deskripsi.isEmpty ? 'Tidak ada deskripsi.' : tugas.deskripsi,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              // Lampiran & Link
              if (tugas.linkTugas.isNotEmpty) ...[
                const Text(
                  'Link Tugas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(tugas.linkTugas);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      Get.snackbar('Error', 'Tidak dapat membuka tautan');
                    }
                  },
                  child: Text(
                    tugas.linkTugas,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (tugas.fileLampiran.isNotEmpty) ...[
                const Text(
                  'File Lampiran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tugas.fileLampiran.split('/').last,
                          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download, color: AppColors.primary),
                        onPressed: () async {
                          // Untuk download/open file
                          final uri = Uri.parse(tugas.fileLampiran);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

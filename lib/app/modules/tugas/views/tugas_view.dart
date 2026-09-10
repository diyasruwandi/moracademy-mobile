import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/tugas_controller.dart';
import '../../../../models/tugas_model.dart';
import '../../../routes/app_pages.dart';

class TugasView extends GetView<TugasController> {
  const TugasView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Tugas Harian',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.tugasList.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => controller.loadTugas(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    'Tidak ada tugas',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.loadTugas(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.tugasList.length,
            itemBuilder: (context, index) {
              final tugas = controller.tugasList[index];
              return _buildTaskItem(tugas, index == controller.tugasList.length - 1);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.TUGAS_FORM),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskItem(TugasModel tugas, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textHint.withValues(alpha: 0.4),
                    border: Border.all(
                      color: AppColors.textHint,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.textHint.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Task card
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.TUGAS_DETAIL, arguments: tugas),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From → To badges
                    Row(
                      children: [
                        _badge(tugas.tanggalTugas, AppColors.primary.withValues(alpha: 0.1), AppColors.primary),
                        if (tugas.media.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.circle, size: 4, color: AppColors.textHint),
                          ),
                          _badge(tugas.media, const Color(0xFFFFF3E0), const Color(0xFFE65100)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      tugas.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      tugas.deskripsi.isEmpty ? 'Tidak ada deskripsi' : tugas.deskripsi,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_menu_button.dart';
import '../../../../models/presensi_model.dart';
import '../../main_nav/controllers/main_nav_controller.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (Get.isRegistered<MainNavController>()) {
              Get.find<MainNavController>().changePage(0);
            } else {
              Get.back();
            }
          },
        ),
        title: const Text(
          'Riwayat Presensi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          const AppMenuButton(),
        ],
      ),
      body: Column(
        children: [
          // Tab bar & month filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Tab chips
                Obx(() => _tabChip('Presensi', 0)),
                const SizedBox(width: 8),
                Obx(() => _tabChip('Izin', 1)),
                const Spacer(),
                // Month filter
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.selectedMonth.value,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: Obx(() {
              final list = controller.selectedTab.value == 0
                  ? controller.presensiList
                  : controller.izinList;

              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada data',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length + 1,
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'You have reached the end of the list',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }
                  return _buildPresensiItem(list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, int index) {
    final isActive = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.switchTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPresensiItem(PresensiModel presensi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          // Status face
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: controller.getStatusMood(presensi) == 'sad'
                  ? const Color(0xFFF44336)
                  : const Color(0xFF57C7B4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(25, 25),
                painter: _StatusFacePainter(
                  mood: controller.getStatusMood(presensi),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  presensi.tanggal,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _timeIndicator(
                      presensi.jamMasuk != '--:--'
                          ? AppColors.success
                          : AppColors.textHint,
                      'Masuk: ${presensi.jamMasuk}',
                    ),
                    const SizedBox(width: 12),
                    _timeIndicator(
                      presensi.jamPulang != '--:--'
                          ? AppColors.textSecondary
                          : AppColors.textHint,
                      'Pulang: ${presensi.jamPulang}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: presensi.tipe == 'IZIN'
                  ? AppColors.badgeIzin
                  : presensi.tipe == 'WFH'
                      ? AppColors.badgeWFH
                      : AppColors.badgeWFO,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              presensi.tipe,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeIndicator(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _StatusFacePainter extends CustomPainter {
  final String mood;

  _StatusFacePainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final face = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);

    canvas.drawCircle(face.center, face.width / 2, paint);

    final eyeY = size.height * 0.42;
    if (mood == 'sad') {
      canvas.drawCircle(Offset(size.width * 0.35, eyeY), 1.2, paint);
      canvas.drawCircle(Offset(size.width * 0.65, eyeY), 1.2, paint);
      final mouth = Path()
        ..moveTo(size.width * 0.34, size.height * 0.70)
        ..quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.57,
          size.width * 0.66,
          size.height * 0.70,
        );
      canvas.drawPath(mouth, paint);
    } else if (mood == 'neutral') {
      canvas.drawCircle(Offset(size.width * 0.35, eyeY), 1, paint);
      canvas.drawCircle(Offset(size.width * 0.65, eyeY), 1, paint);
      canvas.drawLine(
        Offset(size.width * 0.35, size.height * 0.68),
        Offset(size.width * 0.65, size.height * 0.68),
        paint,
      );
    } else {
      final leftEye = Path()
        ..moveTo(size.width * 0.27, eyeY + 1)
        ..quadraticBezierTo(
          size.width * 0.35,
          eyeY - 3,
          size.width * 0.43,
          eyeY + 1,
        );
      final rightEye = Path()
        ..moveTo(size.width * 0.57, eyeY + 1)
        ..quadraticBezierTo(
          size.width * 0.65,
          eyeY - 3,
          size.width * 0.73,
          eyeY + 1,
        );
      canvas.drawPath(leftEye, paint);
      canvas.drawPath(rightEye, paint);
      final mouth = Path()
        ..moveTo(size.width * 0.32, size.height * 0.60)
        ..quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.82,
          size.width * 0.68,
          size.height * 0.60,
        );
      canvas.drawPath(mouth, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StatusFacePainter oldDelegate) =>
      oldDelegate.mood != mood;
}

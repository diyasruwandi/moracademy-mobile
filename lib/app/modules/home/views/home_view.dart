import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildAttendanceCard(),
              const SizedBox(height: 16),
              _buildStatsRow(),
              const SizedBox(height: 12),
              _buildInfoRow(),
              const SizedBox(height: 20),
              _buildMenuGrid(),
              const SizedBox(height: 20),
              _buildBanner(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Center(
            child: CustomPaint(
              size: const Size(24, 24),
              painter: _MiniLogoPainter(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Name and status
        Expanded(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'MORACADEMY',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${controller.user.value.nama} • Magang',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'D3 / S1',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Menu button
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) async {
            switch (value) {
              case 'profil':
                Get.toNamed(Routes.PROFIL);
                break;
              case 'bantuan':
                Get.toNamed(Routes.BANTUAN);
                break;
              case 'tentang':
                Get.toNamed(Routes.TENTANG);
                break;
              case 'logout':
                final result = await ConfirmationDialog.show(
                  Get.context!,
                  message: 'Apakah anda yakin ingin keluar?',
                );
                if (result == true) {
                  Get.offAllNamed(Routes.LOGIN);
                }
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'profil', child: Text('Profil')),
            const PopupMenuItem(value: 'bantuan', child: Text('Bantuan')),
            const PopupMenuItem(value: 'tentang', child: Text('Tentang')),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _attendanceRow(
                  AppColors.success,
                  'Tepat Waktu',
                  controller.tepatWaktu,
                ),
                const SizedBox(height: 10),
                _attendanceRow(
                  AppColors.warning,
                  'Terlambat 1 Kali',
                  controller.terlambat,
                ),
                const SizedBox(height: 10),
                _attendanceRow(
                  AppColors.error,
                  'Kali Tidak Presensi',
                  controller.tidakPresensi,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Calendar icon placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceRow(Color dotColor, String label, RxInt value) {
    return Obx(
      () {
        final v = value.value; // Always read the observable
        return Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$v $label',
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard('45', 'Sisa Hari'),
        const SizedBox(width: 12),
        _statCard('1', 'Jadwal Hari\nIni'),
        const SizedBox(width: 12),
        _statCard('75%', 'Tepat Waktu'),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Obx(
      () => Row(
        children: [
          Text(
            '${controller.notifikasi.value} Notifikasi',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              controller.currentDateTime.value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _menuItem(Icons.calendar_month, 'Jadwal', () {
          Get.toNamed(Routes.JADWAL);
        }),
        _menuItem(Icons.description_outlined, 'Izin', () {
          Get.toNamed(Routes.IZIN);
        }),
        _menuItem(Icons.checklist_outlined, 'Tugas', () {
          Get.toNamed(Routes.TUGAS);
        }),
        _menuItem(Icons.info_outline, 'Informasi', () {
          Get.toNamed(Routes.INFORMASI);
        }),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Panduan & Laporan Magang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dokumen & Modul Onboarding 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}

class _MiniLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.05, h * 0.95);
    path.lineTo(w * 0.05, h * 0.25);
    path.lineTo(w * 0.2, h * 0.25);
    path.lineTo(w * 0.2, h * 0.95);
    path.close();
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(w * 0.05, h * 0.25);
    path2.lineTo(w * 0.5, h * 0.0);
    path2.lineTo(w * 0.5, h * 0.2);
    path2.lineTo(w * 0.2, h * 0.35);
    path2.close();
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(w * 0.95, h * 0.25);
    path3.lineTo(w * 0.5, h * 0.0);
    path3.lineTo(w * 0.5, h * 0.2);
    path3.lineTo(w * 0.8, h * 0.35);
    path3.close();
    canvas.drawPath(path3, paint);

    final path4 = Path();
    path4.moveTo(w * 0.8, h * 0.25);
    path4.lineTo(w * 0.95, h * 0.25);
    path4.lineTo(w * 0.95, h * 0.95);
    path4.lineTo(w * 0.8, h * 0.95);
    path4.close();
    canvas.drawPath(path4, paint);

    final path5 = Path();
    path5.moveTo(w * 0.3, h * 0.45);
    path5.lineTo(w * 0.5, h * 0.7);
    path5.lineTo(w * 0.7, h * 0.45);
    path5.lineTo(w * 0.6, h * 0.45);
    path5.lineTo(w * 0.5, h * 0.58);
    path5.lineTo(w * 0.4, h * 0.45);
    path5.close();
    canvas.drawPath(path5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

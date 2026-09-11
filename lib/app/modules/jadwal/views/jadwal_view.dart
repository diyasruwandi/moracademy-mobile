import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controllers/jadwal_controller.dart';

class JadwalView extends GetView<JadwalController> {
  const JadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Jadwal'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendar(),
            const SizedBox(height: 24),
            const Text(
              'Jadwal Kerja Anda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildScheduleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Obx(() {
      final month = controller.currentMonth.value;
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
      ];

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: controller.previousMonth,
                ),
                Text(
                  '${months[month.month - 1]} ${month.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: controller.nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Day headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                  .asMap()
                  .entries
                  .map((entry) {
                    final isWeekend = entry.key == 5 || entry.key == 6; // Sabtu & Minggu is red
                    return SizedBox(
                      width: 36,
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isWeekend ? AppColors.error : AppColors.textPrimary,
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            _buildCalendarGrid(month),
          ],
        ),
      );
    });
  }

  Widget _buildCalendarGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startWeekday = firstDay.weekday; // 1 = Monday

    List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Add empty cells for days before the first day
    for (int i = 1; i < startWeekday; i++) {
      currentRow.add(const SizedBox(width: 36, height: 36));
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(month.year, month.month, day);
      final isToday = controller.isToday(date);
      final isSelected = controller.isSelected(date);
      final isWeekend = date.weekday == 6 || date.weekday == 7 || controller.isTanggalMerah(date); // Sabtu, Minggu, atau Tanggal Merah is red

      currentRow.add(
        GestureDetector(
          onTap: () => controller.selectDate(date),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? AppColors.primary
                          : isWeekend
                              ? AppColors.error
                              : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      );

      if ((startWeekday - 1 + day) % 7 == 0 || day == lastDay.day) {
        // Pad remaining cells
        while (currentRow.length < 7) {
          currentRow.add(const SizedBox(width: 36, height: 36));
        }
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: currentRow,
            ),
          ),
        );
        currentRow = [];
      }
    }

    return Column(children: rows);
  }

  Widget _buildScheduleList() {
    return Obx(() {
      if (controller.jadwalList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Tidak ada jadwal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        );
      }

      return Column(
        children: controller.jadwalList.map((jadwal) {
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jadwal.tanggal,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _timeChip(AppColors.success, 'Masuk: ${jadwal.jamMasuk}'),
                          const SizedBox(width: 8),
                          _timeChip(AppColors.textSecondary, 'Pulang: ${jadwal.jamPulang}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.badgeWFO,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    jadwal.tipe,
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
        }).toList(),
      );
    });
  }

  Widget _timeChip(Color dotColor, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
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

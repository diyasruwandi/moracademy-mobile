import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import '../constants/app_colors.dart';
import 'confirmation_dialog.dart';

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) => _handleSelection(context, value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'profil', child: Text('Profil')),
        PopupMenuItem(value: 'bantuan', child: Text('Bantuan')),
        PopupMenuItem(value: 'tentang', child: Text('Tentang')),
        PopupMenuItem(
          value: 'logout',
          child: Text('Logout', style: TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }

  Future<void> _handleSelection(BuildContext context, String value) async {
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
          context,
          message: 'Apakah anda yakin ingin keluar?',
        );
        if (result == true) {
          Get.offAllNamed(Routes.LOGIN);
        }
        break;
    }
  }
}

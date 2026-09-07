import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/moracademy_logo.dart';
import 'package:moracademy_mobile/app/routes/app_pages.dart';

class ForgotPasswordSuccessView extends StatelessWidget {
  const ForgotPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const LogoDecorations(
                child: MoracademyLogo(size: 120, showName: true),
              ),
              const Spacer(),
              const Text(
                'Password baru telah dibuat dan\ndikirimkan ke akun WhatsApp\nanda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.LOGIN),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

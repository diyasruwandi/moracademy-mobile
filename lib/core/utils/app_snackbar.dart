import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class AppSnackbar {
  static void _showBubble(String title, Color iconColor, IconData icon, [String? message]) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.TOP,
        // Calculate margin to roughly center it on screen
        margin: EdgeInsets.only(top: Get.height * 0.35, left: 50, right: 50),
        duration: const Duration(milliseconds: 1800),
        animationDuration: const Duration(milliseconds: 400),
        messageText: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 54),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (message != null && message.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static void showSuccess(String title, [String? message]) {
    _showBubble(title, Colors.green, Icons.check_circle_outline, message);
  }

  static void showError(String title, [String? message]) {
    _showBubble(title, Colors.red, Icons.error_outline, message);
  }

  static void showWarning(String title, [String? message]) {
    _showBubble(title, Colors.orange, Icons.warning_amber_rounded, message);
  }
}

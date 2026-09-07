import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access controller to trigger onInit/onReady
    final _ = controller;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: child,
              ),
            );
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(60, 60),
                painter: _SplashLogoPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashLogoPainter extends CustomPainter {
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

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MoracademyLogo extends StatelessWidget {
  final double size;
  final bool showName;
  final bool isWhite;

  const MoracademyLogo({
    super.key,
    this.size = 100,
    this.showName = true,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isWhite ? Colors.white : Colors.transparent,
            border: isWhite
                ? null
                : Border.all(color: AppColors.primary, width: 3),
          ),
          child: Center(
            child: _buildLogoIcon(),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 12),
          Text(
            'MORACADEMY',
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.w800,
              color: isWhite ? Colors.white : AppColors.primary,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLogoIcon() {
    final iconColor = isWhite ? AppColors.primary : AppColors.primary;
    return CustomPaint(
      size: Size(size * 0.55, size * 0.55),
      painter: _MLogoPainter(color: iconColor),
    );
  }
}

class _MLogoPainter extends CustomPainter {
  final Color color;

  _MLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Draw stylized "M" logo
    final path = Path();

    // Left vertical bar
    path.moveTo(w * 0.05, h * 0.95);
    path.lineTo(w * 0.05, h * 0.25);
    path.lineTo(w * 0.2, h * 0.25);
    path.lineTo(w * 0.2, h * 0.95);
    path.close();

    // Left diagonal
    final path2 = Path();
    path2.moveTo(w * 0.05, h * 0.25);
    path2.lineTo(w * 0.5, h * 0.0);
    path2.lineTo(w * 0.5, h * 0.2);
    path2.lineTo(w * 0.2, h * 0.35);
    path2.close();

    // Right diagonal
    final path3 = Path();
    path3.moveTo(w * 0.95, h * 0.25);
    path3.lineTo(w * 0.5, h * 0.0);
    path3.lineTo(w * 0.5, h * 0.2);
    path3.lineTo(w * 0.8, h * 0.35);
    path3.close();

    // Right vertical bar
    final path4 = Path();
    path4.moveTo(w * 0.8, h * 0.25);
    path4.lineTo(w * 0.95, h * 0.25);
    path4.lineTo(w * 0.95, h * 0.95);
    path4.lineTo(w * 0.8, h * 0.95);
    path4.close();

    // Center V
    final path5 = Path();
    path5.moveTo(w * 0.3, h * 0.45);
    path5.lineTo(w * 0.5, h * 0.7);
    path5.lineTo(w * 0.7, h * 0.45);
    path5.lineTo(w * 0.6, h * 0.45);
    path5.lineTo(w * 0.5, h * 0.58);
    path5.lineTo(w * 0.4, h * 0.45);
    path5.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
    canvas.drawPath(path5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Decorative dots and crosses around logo (for login / forgot password screens)
class LogoDecorations extends StatelessWidget {
  final Widget child;

  const LogoDecorations({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative elements
          ..._buildDecorations(),
          // Center logo
          child,
        ],
      ),
    );
  }

  List<Widget> _buildDecorations() {
    return [
      // Dots
      _dot(30, 50, 8, AppColors.dotBlue),
      _dot(80, 30, 5, AppColors.dotGrey),
      _dot(150, 25, 10, AppColors.dotBlue),
      _dot(50, 100, 6, AppColors.dotBlue),
      _dot(100, 80, 4, AppColors.dotGrey),
      _dot(310, 40, 6, AppColors.dotGreen),
      _dot(280, 70, 4, AppColors.dotGrey),
      _dot(340, 90, 5, AppColors.dotBlue),
      _dot(60, 150, 5, AppColors.dotBlue),
      // Crosses
      _cross(20, 130, AppColors.primary),
      _cross(35, 180, AppColors.primary, size: 20),
      _cross(140, 60, AppColors.primary, size: 10),
      _cross(200, 55, AppColors.primary, size: 8),
      _cross(320, 50, AppColors.textHint, size: 12),
      _cross(350, 30, AppColors.primary, size: 8),
      _cross(260, 170, AppColors.dotGreen, size: 12),
      // Dashes
      _dash(90, 200, AppColors.textHint),
      _dash(270, 200, AppColors.textHint),
    ];
  }

  static Widget _dot(double left, double top, double radius, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  static Widget _cross(double left, double top, Color color, {double size = 14}) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CrossPainter(color: color),
        ),
      ),
    );
  }

  static Widget _dash(double left, double top, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 16,
        height: 3,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  final Color color;

  _CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

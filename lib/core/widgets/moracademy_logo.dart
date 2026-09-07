import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';

const moracademyLogoAsset = 'assets/images/logo.svg';

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
        SizedBox(
          width: size,
          height: size,
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
    return SvgPicture.asset(
      moracademyLogoAsset,
      width: size * 0.62,
      height: size * 0.62,
      fit: BoxFit.contain,
    );
  }
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
      _dot(const Alignment(-0.86, -0.78), 8, AppColors.dotBlue),
      _dot(const Alignment(-0.54, -0.94), 5, AppColors.dotGrey),
      _dot(const Alignment(0.2, -0.95), 10, AppColors.dotBlue),
      _dot(const Alignment(0.84, -0.76), 6, AppColors.dotBlue),
      _dot(const Alignment(-0.9, 0.18), 5, AppColors.dotBlue),
      _dot(const Alignment(0.9, 0.16), 6, AppColors.dotBlue),
      _dot(const Alignment(-0.68, 0.82), 5, AppColors.dotBlue),
      _dot(const Alignment(0.66, 0.8), 5, AppColors.dotBlue),
      // Crosses
      _cross(const Alignment(-0.92, -0.12), AppColors.primary),
      _cross(const Alignment(-0.78, 0.52), AppColors.primary, size: 20),
      _cross(const Alignment(0.9, -0.08), AppColors.primary, size: 12),
      _cross(const Alignment(0.78, 0.52), AppColors.primary, size: 10),
      _cross(const Alignment(0.55, -0.9), AppColors.textHint, size: 8),
      _cross(const Alignment(-0.42, 0.9), AppColors.primary, size: 8),
      // Dashes
      _dash(const Alignment(-0.55, 0.98), AppColors.textHint),
      _dash(const Alignment(0.55, 0.98), AppColors.textHint),
    ];
  }

  static Widget _dot(Alignment alignment, double radius, Color color) {
    return Align(
      alignment: alignment,
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

  static Widget _cross(Alignment alignment, Color color, {double size = 14}) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CrossPainter(color: color),
        ),
      ),
    );
  }

  static Widget _dash(Alignment alignment, Color color) {
    return Align(
      alignment: alignment,
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

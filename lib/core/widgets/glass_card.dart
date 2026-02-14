import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final double border;

  const GlassCard({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius = 20,
    this.blur = 20,
    this.border = 1.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.center,
      border: border,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.glassSurface.withOpacity(0.1),
          AppTheme.glassSurface.withOpacity(0.05),
        ],
        stops: const [0.1, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.glassSurface.withOpacity(0.5),
          AppTheme.glassSurface.withOpacity(0.2),
        ],
      ),
      child: child,
    );
  }
}

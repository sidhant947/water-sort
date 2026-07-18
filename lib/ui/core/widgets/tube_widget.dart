import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:watersort/ui/core/theme/app_colors.dart';
import 'package:watersort/domain/models/tube.dart';

class TubeWidget extends StatefulWidget {
  const TubeWidget({
    super.key,
    required this.tube,
    this.isSelected = false,
    this.isPouringSource = false,
    this.isPouringTarget = false,
    this.pourToLeft = false,
    this.pouringOffset = Offset.zero,
    this.onTap,
    this.height = 180,
    this.width = 56,
  });

  final Tube tube;
  final bool isSelected;
  final bool isPouringSource;
  final bool isPouringTarget;
  final bool pourToLeft;
  final Offset pouringOffset;
  final VoidCallback? onTap;
  final double height;
  final double width;

  @override
  State<TubeWidget> createState() => _TubeWidgetState();
}

class _TubeWidgetState extends State<TubeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final int _bubbleSeed;

  @override
  void initState() {
    super.initState();
    _bubbleSeed = math.Random().nextInt(1000000);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.value = math.Random().nextDouble();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIconForColor(Color color) {
    final hex = color.toARGB32() & 0xFFFFFF;
    switch (hex) {
      case 0xE53935: return Icons.favorite_rounded;
      case 0x1E88E5: return Icons.water_drop_rounded;
      case 0x43A047: return Icons.eco_rounded;
      case 0xFDD835: return Icons.wb_sunny_rounded;
      case 0xFFFF8F00: return Icons.star_rounded;
      case 0x8E24AA: return Icons.dark_mode_rounded;
      case 0xEC407A: return Icons.auto_awesome_rounded;
      case 0x00ACC1: return Icons.ac_unit_rounded;
      case 0xB39DDB: return Icons.palette_rounded;
      case 0xFF7043: return Icons.whatshot_rounded;
      case 0x5C6BC0: return Icons.cloud_rounded;
      case 0x009688: return Icons.diamond_rounded;
      case 0x8D6E63: return Icons.cookie_rounded;
      case 0xB71C1C: return Icons.bolt_rounded;
      case 0xAD1457: return Icons.nightlight_rounded;
      case 0x9E9D24: return Icons.grass_rounded;
      default: return Icons.brightness_1_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomRadius = widget.width / 2;
    const double topRadius = 6.0;
    const double borderWidth = 1.8;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double yOffset = 0;
        double pulseScale = 1.0;
        if (widget.isSelected) {
          yOffset = -18 + 3.0 * math.sin(_controller.value * 2 * math.pi);
          pulseScale = 1.0 + 0.12 * math.sin(_controller.value * 2 * math.pi);
        }

        final accentColor = AppColors.accent;

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: const Color(0xFF16161C).withOpacity(0.85),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(bottomRadius),
                  top: Radius.circular(topRadius),
                ),
                border: Border.all(
                  color: widget.isSelected ? accentColor : const Color(0xFF2D2D35),
                  width: widget.isSelected ? 2.4 : borderWidth,
                ),
                boxShadow: [
                  if (widget.isSelected)
                    BoxShadow(
                      color: accentColor.withOpacity(0.5 * pulseScale),
                      blurRadius: 18 * pulseScale,
                      spreadRadius: 1.8 * pulseScale,
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Liquid and animations
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(bottomRadius - borderWidth),
                        top: Radius.circular(topRadius - borderWidth),
                      ),
                      child: Stack(
                        children: [
                          // 3D Liquid columns painter with meniscus
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _LiquidPainter(
                                colors: widget.tube.colors,
                                capacity: widget.tube.capacity,
                                animationValue: _controller.value,
                                isFast: widget.isSelected,
                              ),
                            ),
                          ),

                          // Icons Overlay Column
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: List.generate(
                                widget.tube.colors.length,
                                (i) {
                                  final logicalIndex = widget.tube.colors.length - 1 - i;
                                  final color = widget.tube.colors[logicalIndex];
                                  final segmentHeight = (widget.height - 12) / widget.tube.capacity;
                                  return SizedBox(
                                    height: segmentHeight,
                                    width: widget.width,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.18),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getIconForColor(color),
                                          color: Colors.white.withOpacity(0.85),
                                          size: widget.width * 0.36,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Bubbles rising inside liquid
                          if (widget.tube.colors.isNotEmpty)
                            Positioned.fill(
                              child: ClipPath(
                                clipper: _LiquidClipper(
                                  liquidHeight: (widget.tube.colors.length / widget.tube.capacity) * (widget.height - 12),
                                ),
                                child: CustomPaint(
                                  painter: _BubblePainter(
                                    animationValue: _controller.value,
                                    isFast: widget.isSelected,
                                    seed: _bubbleSeed,
                                  ),
                                ),
                              ),
                            ),

                          // Dual glass specularity highlights (Left sheen)
                          Positioned(
                            top: 4,
                            left: 4,
                            bottom: 4,
                            width: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    Colors.white.withOpacity(0.05),
                                    Colors.white.withOpacity(0),
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // Dual glass specularity highlights (Right sheen)
                          Positioned(
                            top: 4,
                            right: 3,
                            bottom: 4,
                            width: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Rim/Lip highlights
                  Positioned(
                    top: -2.5,
                    left: -2,
                    right: -2,
                    height: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E26),
                        borderRadius: BorderRadius.circular(2.5),
                        border: Border.all(
                          color: widget.isSelected ? accentColor : const Color(0xFF33333C),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({
    required this.colors,
    required this.capacity,
    required this.animationValue,
    required this.isFast,
  });

  final List<Color> colors;
  final int capacity;
  final double animationValue;
  final bool isFast;

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    final double segmentHeight = size.height / capacity;
    const double meniscusDepth = 3.5;

    for (int i = 0; i < colors.length; i++) {
      final color = colors[i];
      final double bottomY = size.height - (i * segmentHeight);
      final double topY = size.height - ((i + 1) * segmentHeight);

      final path = Path();
      path.moveTo(0, bottomY);

      if (i == 0) {
        path.lineTo(size.width, bottomY);
      } else {
        path.quadraticBezierTo(size.width / 2, bottomY + meniscusDepth, size.width, bottomY);
      }

      path.lineTo(size.width, topY);

      if (i == colors.length - 1) {
        final double amplitude = isFast ? 3.5 : 2.0;
        final double frequencyFactor = isFast ? 2.0 : 1.0;
        for (double x = size.width; x >= 0; x -= 2) {
          final y = topY +
              math.sin((x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi * frequencyFactor)) * amplitude;
          path.lineTo(x, y);
        }
      } else {
        path.quadraticBezierTo(size.width / 2, topY + meniscusDepth, 0, topY);
      }

      path.close();

      final Color highlightColor = Color.alphaBlend(Colors.white.withOpacity(0.18), color);
      final Color shadowColor = Color.alphaBlend(Colors.black.withOpacity(0.15), color);
      
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            shadowColor,
            highlightColor,
            color,
            shadowColor,
          ],
          stops: const [0.0, 0.22, 0.65, 1.0],
        ).createShader(Rect.fromLTRB(0, topY, size.width, bottomY));

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.animationValue != animationValue ||
      oldDelegate.isFast != isFast;
}

class _BubblePainter extends CustomPainter {
  final double animationValue;
  final bool isFast;
  final int seed;

  _BubblePainter({
    required this.animationValue,
    required this.isFast,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final double speedMultiplier = isFast ? 2.0 : 1.0;
    final random = math.Random(seed);

    for (int i = 0; i < 6; i++) {
      final xRatio = random.nextDouble();
      final yRatio = random.nextDouble();
      final bubbleSize = random.nextDouble() * 2.5 + 1.5;
      final speed = (random.nextInt(2) + 1).toDouble(); // 1.0 or 2.0 integer speeds for seamless wrap-around

      final x = xRatio * size.width;
      double y = size.height - ((yRatio + animationValue * speed * speedMultiplier) % 1.0) * size.height;
      canvas.drawCircle(Offset(x, y), bubbleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => true;
}

class _LiquidClipper extends CustomClipper<Path> {
  final double liquidHeight;

  _LiquidClipper({required this.liquidHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height - liquidHeight);
    path.lineTo(size.width, size.height - liquidHeight);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _LiquidClipper oldDelegate) =>
      oldDelegate.liquidHeight != liquidHeight;
}

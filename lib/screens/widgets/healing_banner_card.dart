import 'dart:math';
import 'package:flutter/material.dart';

/// ──────────────────────────────────────────────
/// HealingBannerCard
/// 감성적인 플로팅 카드 배너 위젯
/// 부드러운 그라디언트 + 미세 플로팅 + 터치 바운스
/// ──────────────────────────────────────────────
class HealingBannerCard extends StatefulWidget {
  final String title;
  final String emoji;
  final String tagline;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final int animationIndex;

  const HealingBannerCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.tagline,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  State<HealingBannerCard> createState() => _HealingBannerCardState();
}

class _HealingBannerCardState extends State<HealingBannerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    final duration = 2500 + (widget.animationIndex * 400);
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset =
            sin((_floatController.value * 2 * pi) +
                    (widget.animationIndex * 0.8)) *
                4.0;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                widget.gradientColors[0],
                widget.gradientColors[1],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[1].withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // 다크 오버레이
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // 배경 장식 아이콘
                Positioned(
                  right: -15,
                  bottom: -15,
                  child: Icon(
                    widget.icon,
                    size: 120,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                // 컨텐츠
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(widget.emoji,
                                    style: const TextStyle(fontSize: 28)),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black26,
                                            blurRadius: 4),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.tagline,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.5,
                                shadows: const [
                                  Shadow(
                                      color: Colors.black12, blurRadius: 3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

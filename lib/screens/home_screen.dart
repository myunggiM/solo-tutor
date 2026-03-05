import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/category_data.dart';
import 'widgets/healing_banner_card.dart';
import 'post_list_page.dart';

/// ──────────────────────────────────────────────
/// HomeScreen: 소통과 힐링 컨셉
/// 따뜻한 아이보리 배경 + 감성 카드 배너
/// ──────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── 인사 헤더 ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '안녕 👋',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '오늘도 나를\n알아가볼까?',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E2E2E),
                        height: 1.3,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // ── 내면(Inner) 섹션 ──
              _buildSectionLabel(
                CategoryData.sectionLabels['내면(Inner)']!,
                '🌙',
              ),
              const SizedBox(height: 12),
              ..._buildBanners(context, '내면(Inner)', startIndex: 0),

              const SizedBox(height: 40),

              // ── 외면(Outer) 섹션 ──
              _buildSectionLabel(
                CategoryData.sectionLabels['외면(Outer)']!,
                '✨',
              ),
              const SizedBox(height: 12),
              ..._buildBanners(context, '외면(Outer)', startIndex: 3),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  /// 섹션 라벨 위젯
  Widget _buildSectionLabel(String label, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.notoSansKr(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5A5A5A),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// 해당 대분류의 배너 리스트 생성
  List<Widget> _buildBanners(
    BuildContext context,
    String mainCategory, {
    required int startIndex,
  }) {
    final subs = CategoryData.categoryMap[mainCategory]!;
    return subs.asMap().entries.map((entry) {
      final idx = entry.key;
      final subName = entry.value;
      final info = CategoryData.subCategoryDetails[subName]!;

      return HealingBannerCard(
        title: info.name,
        emoji: info.emoji,
        tagline: info.tagline,
        icon: info.icon,
        gradientColors: info.gradientColors,
        animationIndex: startIndex + idx,
        onTap: () {
          Navigator.of(context).push(
            PostListPage.fadeRoute(
              subcategory: subName,
              emoji: info.emoji,
              gradientColors: info.gradientColors,
            ),
          );
        },
      );
    }).toList();
  }
}

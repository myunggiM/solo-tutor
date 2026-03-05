import 'package:flutter/material.dart';

/// ──────────────────────────────────────────────
/// 카테고리 데이터 모델 (Inner / Outer)
/// CreatePostPage와 HomeScreen에서 공유
/// ──────────────────────────────────────────────

class SubCategoryInfo {
  final String name;
  final String emoji;
  final String tagline;
  final List<Color> gradientColors;
  final IconData icon;

  const SubCategoryInfo({
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.gradientColors,
    required this.icon,
  });
}

class CategoryData {
  CategoryData._();

  /// CreatePostPage와 동일한 카테고리 맵
  static const categoryMap = <String, List<String>>{
    '내면(Inner)': ['카톡 팩폭', 'MBTI', '사주/타로'],
    '외면(Outer)': ['패션 고자 탈출', '첫인상 스캔', '매너/태도'],
  };

  /// 대분류 키 목록
  static const mainCategories = ['내면(Inner)', '외면(Outer)'];

  /// 대분류별 감성 라벨
  static const sectionLabels = <String, String>{
    '내면(Inner)': '마음 속 나를 들여다볼까?',
    '외면(Outer)': '세상에 보여줄 나, 다듬어볼까?',
  };

  /// 소분류별 상세 정보 (감성 문구 + 그라디언트 + 아이콘)
  static const subCategoryDetails = <String, SubCategoryInfo>{
    // ── Inner ──
    '카톡 팩폭': SubCategoryInfo(
      name: '카톡 팩폭',
      emoji: '💬',
      tagline: '진짜 내 말투,\n돌아볼까?',
      gradientColors: [Color(0xFFB39DDB), Color(0xFF7E57C2)],
      icon: Icons.chat_bubble_outline_rounded,
    ),
    'MBTI': SubCategoryInfo(
      name: 'MBTI',
      emoji: '🧩',
      tagline: '나도 몰랐던\n내 마음 속',
      gradientColors: [Color(0xFF90CAF9), Color(0xFF5C6BC0)],
      icon: Icons.psychology_outlined,
    ),
    '사주/타로': SubCategoryInfo(
      name: '사주/타로',
      emoji: '🔮',
      tagline: '오늘의 운세,\n한번 볼까?',
      gradientColors: [Color(0xFFCE93D8), Color(0xFF8E24AA)],
      icon: Icons.auto_awesome_outlined,
    ),

    // ── Outer ──
    '패션 고자 탈출': SubCategoryInfo(
      name: '패션 고자 탈출',
      emoji: '👕',
      tagline: '나만의 스타일,\n찾아볼까?',
      gradientColors: [Color(0xFFFFCC80), Color(0xFFFF7043)],
      icon: Icons.checkroom_outlined,
    ),
    '첫인상 스캔': SubCategoryInfo(
      name: '첫인상 스캔',
      emoji: '👀',
      tagline: '사람들 눈에\n나는 어때?',
      gradientColors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
      icon: Icons.face_retouching_natural_outlined,
    ),
    '매너/태도': SubCategoryInfo(
      name: '매너/태도',
      emoji: '🤝',
      tagline: '따뜻한 사람이\n되어볼까?',
      gradientColors: [Color(0xFFA5D6A7), Color(0xFF43A047)],
      icon: Icons.emoji_people_outlined,
    ),
  };
}

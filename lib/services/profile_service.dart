import 'package:supabase_flutter/supabase_flutter.dart';

/// 테스트용 사용자 ID 목록 (F~GOD 등급별)
const List<String> testUserIds = [
  '00000000-0000-0000-0000-000000000000', // F등급
  '11111111-1111-1111-1111-111111111111', // E등급
  '22222222-2222-2222-2222-222222222222', // D등급
  '33333333-3333-3333-3333-333333333333', // C등급
  '44444444-4444-4444-4444-444444444444', // B등급
  '55555555-5555-5555-5555-555555555555', // A등급
  '66666666-6666-6666-6666-666666666666', // GOD등급
];
const String testUserId = '00000000-0000-0000-0000-000000000000';

/// 리더보드 데이터 모델
class LeaderboardProfile {
  final String id;
  final String nickname;
  final int totalPoints;
  final String tierDisplay;
  final int? nextTierRemaining;

  LeaderboardProfile({
    required this.id,
    required this.nickname,
    required this.totalPoints,
    required this.tierDisplay,
    this.nextTierRemaining,
  });

  factory LeaderboardProfile.fromMap(Map<String, dynamic> map) {
    return LeaderboardProfile(
      id: map['id'] as String,
      nickname: map['nickname'] as String,
      totalPoints: (map['total_points'] as num).toInt(),
      tierDisplay: map['tier_display'] as String? ?? '',
      nextTierRemaining: map['next_tier_remaining'] != null
          ? (map['next_tier_remaining'] as num).toInt()
          : null,
    );
  }
}

/// 프로필/리더보드 서비스
class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// leaderboards 뷰에서 특정 사용자 정보를 가져옴
  Future<LeaderboardProfile?> getMyProfile({String? userId}) async {
    final uid = userId ?? testUserId;

    final response = await _client
        .from('leaderboards')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (response == null) return null;
    return LeaderboardProfile.fromMap(response);
  }

  /// leaderboards 뷰에서 전체 순위를 가져옴
  Future<List<LeaderboardProfile>> getLeaderboard({int limit = 20}) async {
    final response = await _client
        .from('leaderboards')
        .select()
        .order('total_points', ascending: false)
        .limit(limit);

    return (response as List)
        .map((e) => LeaderboardProfile.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}

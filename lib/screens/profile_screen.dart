import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  LeaderboardProfile? _profile;
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0; // 현재 선택된 테스트 유저 인덱스

  static const List<String> _tierLabels = [
    'F', 'E', 'D', 'C', 'B', 'A', 'GOD'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await _profileService.getMyProfile(
        userId: testUserIds[_selectedIndex],
      );
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectUser(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('내 프로필'),
        centerTitle: true,
        backgroundColor: const Color(0xFF16213E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── 등급 선택 바 (테스트용) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            color: const Color(0xFF16213E),
            child: Column(
              children: [
                Text(
                  '🧪 등급별 테스트',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_tierLabels.length, (index) {
                    final isSelected = index == _selectedIndex;
                    return GestureDetector(
                      onTap: () => _selectUser(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? Colors.deepPurpleAccent
                              : Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: isSelected
                                ? Colors.deepPurpleAccent
                                : Colors.white.withOpacity(0.1),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.deepPurpleAccent
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          _tierLabels[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color:
                                isSelected ? Colors.white : Colors.grey[400],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // ── 본문 ──
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent))
                : _error != null
                    ? _buildError()
                    : _profile != null
                        ? _buildProfileCard()
                        : _buildEmpty(),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러올 수 없습니다',
              style: TextStyle(fontSize: 18, color: Colors.grey[300]),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            '프로필을 찾을 수 없습니다',
            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final profile = _profile!;

    // 진행률 계산: next_tier_remaining이 null이면 최고 등급
    final bool isMaxTier = profile.nextTierRemaining == null;
    final double progressValue = isMaxTier
        ? 1.0
        : profile.nextTierRemaining! > 0
            ? profile.totalPoints /
                (profile.totalPoints + profile.nextTierRemaining!)
            : 1.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ── 프로필 아바타 ──
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFFE040FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // ── 등급 + 닉네임 (크게 강조) ──
          Text(
            profile.tierDisplay,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.amberAccent,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  color: Colors.amberAccent,
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile.nickname,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // ── 프로필 카드 ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1E3F), Color(0xFF2A2A5A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // 포인트 섹션
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amberAccent, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      '${profile.totalPoints}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'pts',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 다음 등급 진행도
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isMaxTier ? '🏆 최고 등급 달성!' : '다음 등급까지',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (!isMaxTier)
                            Text(
                              '${profile.nextTierRemaining}pts 남음',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 12,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isMaxTier
                                ? Colors.amberAccent
                                : Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progressValue * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

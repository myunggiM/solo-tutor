import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// ──────────────────────────────────────────────
/// PostListPage
/// 소분류별 게시물 리스트 (배너 클릭 시 페이드 인 전환)
/// ──────────────────────────────────────────────
class PostListPage extends StatefulWidget {
  final String subcategory;
  final String emoji;
  final List<Color> gradientColors;

  const PostListPage({
    super.key,
    required this.subcategory,
    required this.emoji,
    required this.gradientColors,
  });

  /// 페이드 인 전환 라우트
  static Route<void> fadeRoute({
    required String subcategory,
    required String emoji,
    required List<Color> gradientColors,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PostListPage(
        subcategory: subcategory,
        emoji: emoji,
        gradientColors: gradientColors,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _supabase
          .from('posts')
          .select()
          .eq('category', widget.subcategory)
          .order('created_at', ascending: false);

      setState(() {
        _posts = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: Text(
          '${widget.emoji} ${widget.subcategory}',
          style: GoogleFonts.notoSansKr(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3E3E3E),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: widget.gradientColors[1],
              ),
            )
          : _error != null
              ? _buildError()
              : _posts.isEmpty
                  ? _buildEmpty()
                  : _buildPostList(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '앗, 불러오지 못했어요',
              style: GoogleFonts.notoSansKr(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPosts,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                '다시 해볼까?',
                style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.gradientColors[1],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: widget.gradientColors[0].withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '아직 작성된 글이 없어요',
            style: GoogleFonts.notoSansKr(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째로 이야기를 나눠볼까?',
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _PostCard(
          post: post,
          gradientColors: widget.gradientColors,
        );
      },
    );
  }
}

/// ── 개별 포스트 카드 ──
class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final List<Color> gradientColors;

  const _PostCard({
    required this.post,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = post['image_url'] as String?;
    final content = post['content'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지
            if (imageUrl != null)
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: gradientColors[0].withOpacity(0.1),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            // 텍스트
            if (content != null && content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  content,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF3E3E3E),
                    height: 1.6,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

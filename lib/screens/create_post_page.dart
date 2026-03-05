import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/category_data.dart';

/// ──────────────────────────────────────────────
/// 게시글 작성 페이지 (CreatePostPage)
/// ──────────────────────────────────────────────
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // ── Supabase 클라이언트 ──
  final _supabase = Supabase.instance.client;

  // ── 카테고리 맵: 공유 데이터 사용 ──
  static const _categoryMap = CategoryData.categoryMap;

  // ── 상태 ──
  String? _selectedMain; // 대분류
  String? _selectedSub; // 소분류
  XFile? _pickedImage; // 선택된 사진
  final _contentController = TextEditingController();
  bool _isLoading = false;

  // ── 사진 선택 ──
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = picked);
    }
  }

  // ── 유효성 검사 ──
  bool _validate() {
    if (_selectedSub == null || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('항목을 채워주세요 (카테고리 선택 + 사진 첨부 필수)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  // ── 게시글 등록 ──
  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);

    try {
      // 1) 파일명 생성 (Platform.pathSeparator 대신 '/' 사용 또는 단순화)
      // 웹/모바일 공용으로 가장 안전한 방법은 아래와 같습니다.

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}';
      final bytes = await _pickedImage!.readAsBytes();

      // 2) 'supabase' 대신 아래와 같이 직접 호출하세요
      await Supabase.instance.client.storage.from('posts').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      // 2) Public URL 가져오기
      final imageUrl = _supabase.storage.from('posts').getPublicUrl(fileName);

      // 3) posts 테이블 insert
      await _supabase.from('posts').insert({
        'category': _selectedSub,
        'image_url': imageUrl,
        'content': _contentController.text.trim().isEmpty
            ? null
            : _contentController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('게시글이 등록되었습니다! 🎉'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(); // 이전 화면으로
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류 발생: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─────────── BUILD ───────────
  @override
  Widget build(BuildContext context) {
    final subCategories =
        _selectedMain != null ? _categoryMap[_selectedMain]! : <String>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 작성'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. 대분류 선택 카드 ──
              _SectionCard(
                title: '대분류 선택',
                child: Wrap(
                  spacing: 12,
                  children: _categoryMap.keys.map((main) {
                    final selected = _selectedMain == main;
                    return ChoiceChip(
                      label: Text(main),
                      selected: selected,
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedMain = main;
                          _selectedSub = null; // 소분류 초기화
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

              // ── 2. 소분류 선택 카드 (대분류 선택 시 노출) ──
              if (subCategories.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionCard(
                  title: '소분류 선택',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: subCategories.map((sub) {
                      final selected = _selectedSub == sub;
                      return ChoiceChip(
                        label: Text(sub),
                        selected: selected,
                        selectedColor: Colors.deepPurple.shade300,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        onSelected: (_) {
                          setState(() => _selectedSub = sub);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // ── 3. 사진 첨부 카드 ──
              _SectionCard(
                title: '사진 첨부 (필수)',
                child: Column(
                  children: [
                    // 미리보기
                    if (_pickedImage != null)
                      AspectRatio(
                        aspectRatio: 16 / 9, // 원하는 비율로 고정 (예: 16:9)
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _pickedImage!.path,
                            fit: BoxFit.contain, // 절대 안 잘림
                          ),
                        ),
                      ),
                    if (_pickedImage != null) const SizedBox(height: 12),

                    // 사진 선택 버튼
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(
                        _pickedImage == null ? '갤러리에서 선택' : '사진 변경',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.deepPurple),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── 4. 내용 입력 (선택) ──
              _SectionCard(
                title: '한마디 (선택)',
                child: TextField(
                  controller: _contentController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: '하고 싶은 말이 있다면 적어주세요...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── 5. 등록 버튼 ──
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('등록하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────
// 재사용 섹션 카드 위젯
// ─────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

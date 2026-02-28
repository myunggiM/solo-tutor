import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 인증 서비스
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 현재 로그인된 사용자
  User? get currentUser => _client.auth.currentUser;

  /// 인증 상태 변경 스트림
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// 이메일/패스워드 회원가입
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// 이메일/패스워드 로그인
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

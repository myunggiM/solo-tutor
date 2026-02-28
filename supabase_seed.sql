-- Solo-Tutor: 테스트 데이터 삽입
-- Supabase SQL Editor에서 실행하세요

-- profiles 테이블에 테스트 사용자 삽입
INSERT INTO profiles (id, nickname, total_points)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  '모태솔로왕',
  120
)
ON CONFLICT (id) DO UPDATE
SET nickname = EXCLUDED.nickname,
    total_points = EXCLUDED.total_points;

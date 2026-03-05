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

-- posts 테이블 생성 (게시글)
CREATE TABLE IF NOT EXISTS posts (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     UUID REFERENCES auth.users(id),
  category    TEXT NOT NULL,          -- 소분류 명칭
  image_url   TEXT NOT NULL,          -- Storage public URL
  content     TEXT,                   -- 선택적 텍스트
  created_at  TIMESTAMPTZ DEFAULT now()
);

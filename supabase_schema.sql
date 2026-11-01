-- ===================================================================
-- ST. JOSEPH'S SCHOOL, BASTI — ZERO-NUMBER BIOMETRIC SUPABASE SCHEMA
-- ===================================================================

-- 1. Developer Biometric Root Lock Table (Only 1 Developer Master Signature)
create table if not exists public.developer_vault_lock (
  id text primary key default 'DEV_ROOT',
  face_id_token text not null,
  thumb_id_token text not null,
  enrolled_at timestamptz default now()
);

-- 2. Principal Account (One-Time Creation, Overridable ONLY by Developer)
create table if not exists public.principal_account (
  uid text primary key,
  name text not null,
  face_id_token text not null,
  thumb_id_token text not null,
  created_at timestamptz default now()
);

-- 3. Class Teachers (Assigned by Principal, Zero Phone/Email)
create table if not exists public.class_teachers (
  uid text primary key,
  name text not null,
  assigned_class text not null,
  subject text not null,
  face_id_token text not null,
  thumb_id_token text not null,
  created_at timestamptz default now()
);

-- 4. Students Registry (Added by Class Teacher or Principal)
create table if not exists public.students (
  uid text primary key,
  name text not null,
  student_class text not null,
  roll_no integer not null,
  face_id_token text not null,
  thumb_id_token text not null,
  added_by text not null,
  today_status text default 'Present',
  days_present integer default 24,
  total_days integer default 26,
  last_sync_time text,
  created_at timestamptz default now()
);

-- 5. Monthly Exam & Competitive Test Scores Ledger
create table if not exists public.monthly_scores (
  id text primary key,
  student_uid text references public.students(uid) on delete cascade,
  student_name text not null,
  student_class text not null,
  roll_no integer not null,
  exam_month text not null,
  exam_name text not null,
  mark_math integer default 0,
  mark_science integer default 0,
  mark_chem_comp integer default 0,
  mark_english integer default 0,
  mark_jee_foundation integer default 0,
  created_at timestamptz default now()
);

-- 6. Live Attendance Feed (Synced from Class Teachers to Principal)
create table if not exists public.attendance_logs (
  id bigint generated always as identity primary key,
  timestamp_label text not null,
  student_class text not null,
  student_uid text not null,
  roll_no integer not null,
  student_name text not null,
  today_status text not null,
  days_present integer not null,
  total_days integer not null,
  marked_by text not null,
  created_at timestamptz default now()
);

-- 7. Chunked Campus & Student Activity Media Metadata
create table if not exists public.campus_activity_media (
  id text primary key,
  section text not null,
  target_class text not null,
  media_type text not null,
  title text not null,
  description text,
  blob_id text not null,
  uploaded_by text not null,
  created_at timestamptz default now()
);

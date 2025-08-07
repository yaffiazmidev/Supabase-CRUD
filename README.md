# Supabase CRUD Todo App

Aplikasi Todo List sederhana yang dibuat dengan SwiftUI dan Supabase untuk demonstrasi operasi CRUD (Create, Read, Update, Delete).

## Fitur

- ✅ Menambah todo baru
- ✅ Melihat daftar todos
- ✅ Mengedit todo yang sudah ada
- ✅ Menghapus todo
- ✅ Toggle status completed/uncompleted
- ✅ Pull to refresh
- ✅ Real-time data dari Supabase

## Persyaratan

- iOS 16.0+
- Xcode 14.0+
- Account Supabase (gratis)

## Setup Supabase

### 1. Buat Project Supabase

1. Kunjungi [supabase.com](https://supabase.com)
2. Buat account atau login
3. Klik "New Project"
4. Isi nama project dan password database
5. Pilih region terdekat
6. Tunggu project selesai dibuat

### 2. Buat Tabel Database

1. Buka project Supabase Anda
2. Pergi ke "SQL Editor"
3. Jalankan query berikut:

```sql
-- Buat tabel todos
CREATE TABLE todos (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger untuk auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_todos_updated_at
    BEFORE UPDATE ON todos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- Policy untuk allow semua operasi (untuk demo)
CREATE POLICY "Allow all operations" ON todos
    FOR ALL USING (true);
```

### 3. Dapatkan API Keys

1. Pergi ke "Settings" > "API"
2. Copy "Project URL" dan "anon public" key

## Setup Aplikasi iOS

### 1. Install Supabase SDK

1. Buka project di Xcode
2. Pergi ke "File" > "Add Package Dependencies"
3. Masukkan URL: `https://github.com/supabase/supabase-swift`
4. Klik "Add Package"
5. Pilih "Supabase" dan klik "Add Package"

### 2. Konfigurasi Supabase

1. Buka file `Config/SupabaseConfig.swift`
2. Ganti nilai berikut dengan data dari project Supabase Anda:

```swift
static let supabaseURL = "https://your-project-id.supabase.co"
static let supabaseAnonKey = "your-anon-key-here"
```

### 3. Jalankan Aplikasi

1. Build dan run aplikasi di simulator atau device
2. Aplikasi siap digunakan!

## Struktur Project

```
Supabase-CRUD/
├── Models/
│   └── Todo.swift                 # Model data Todo
├── Services/
│   └── SupabaseService.swift      # Service untuk komunikasi dengan Supabase
├── ViewModels/
│   └── TodoViewModel.swift        # ViewModel untuk business logic
├── Views/
│   ├── TodoListView.swift         # View utama daftar todos
│   └── Components/
│       ├── TodoRowView.swift      # Komponen untuk item todo
│       └── TodoFormView.swift     # Form untuk add/edit todo
├── Config/
│   └── SupabaseConfig.swift       # Konfigurasi Supabase
└── ContentView.swift              # Root view
```

## Arsitektur

Aplikasi ini menggunakan arsitektur MVVM (Model-View-ViewModel) dengan:

- **Models**: Struktur data (Todo, TodoInput)
- **Services**: Layer untuk komunikasi dengan API Supabase
- **ViewModels**: Business logic dan state management
- **Views**: UI components dengan SwiftUI

## Troubleshooting

### Error "Invalid API Key"
- Pastikan API key dan URL Supabase sudah benar
- Cek apakah project Supabase masih aktif

### Error "Table doesn't exist"
- Pastikan tabel `todos` sudah dibuat di database
- Cek nama tabel dan kolom sudah sesuai

### Error "Row Level Security"
- Pastikan policy sudah dibuat untuk tabel `todos`
- Untuk development, bisa disable RLS sementara

## Kontribusi

Silakan buat issue atau pull request untuk improvement atau bug fixes.

## Lisensi

MIT License
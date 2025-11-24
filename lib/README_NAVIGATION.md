# 📱 Struktur Tabs Navigator Flutter

## 📂 Struktur Direktori

```
lib/
├── main.dart                          # Entry point aplikasi
├── navigation/                        # Folder untuk navigation logic
│   ├── bottom_nav_bar.dart           # Bottom navigation bar dengan 3 tabs
│   └── app_router.dart               # Router untuk manage routes
├── screens/                          # Folder untuk semua screens
│   ├── home/
│   │   └── home_screen.dart         # Screen Home (Tab 1)
│   ├── search/
│   │   └── search_screen.dart       # Screen Search (Tab 2)
│   └── profile/
│       └── profile_screen.dart      # Screen Profile (Tab 3)
└── widgets/                          # Folder untuk reusable widgets
```

## 🎯 Fitur yang Sudah Dibuat

### 1. **Home Screen** 🏠
- Lokasi: `lib/screens/home/home_screen.dart`
- Fitur: Halaman utama dengan icon home dan welcome message
- Warna: Merah (tema Indonesia)

### 2. **Search Screen** 🔍
- Lokasi: `lib/screens/search/search_screen.dart`
- Fitur: Halaman pencarian dengan search bar
- Input: TextField untuk mencari
- Placeholder: "Cari sesuatu..."

### 3. **Profile Screen** 👤
- Lokasi: `lib/screens/profile/profile_screen.dart`
- Fitur: Halaman profil pengguna dengan menu options
- Menu:
  - Edit Profile
  - Pengaturan
  - Privasi
  - Bantuan
  - Keluar

### 4. **Bottom Navigation Bar** 📱
- Lokasi: `lib/navigation/bottom_nav_bar.dart`
- Fitur: Navigation bar di bagian bawah dengan 3 tab
- Tabs:
  1. Home (ikon: home)
  2. Search (ikon: search)
  3. Profile (ikon: person)
- Warna aktif: Merah
- Warna tidak aktif: Abu-abu

### 5. **App Router** 🛣️
- Lokasi: `lib/navigation/app_router.dart`
- Fitur: Mengelola routing aplikasi
- Helper methods:
  - `navigateTo()` - Navigate ke route
  - `navigateAndReplace()` - Replace current route
  - `goBack()` - Kembali ke screen sebelumnya

## 🎨 Tema Aplikasi

- **Warna Utama**: Merah (Indonesia)
- **Warna Sekunder**: Putih
- **Material Design**: Material 3
- **AppBar**: Centered title dengan elevation

## 🚀 Cara Menggunakan

### 1. Menjalankan Aplikasi
```bash
flutter run
```

### 2. Menambah Tab Baru
Untuk menambah tab keempat, misalnya "Settings":

1. Buat folder dan file baru:
```bash
mkdir lib/screens/settings
touch lib/screens/settings/settings_screen.dart
```

2. Buat screen `settings_screen.dart`
3. Tambahkan di `bottom_nav_bar.dart`:
   - Import screen settings
   - Tambahkan `SettingsScreen()` ke list `_screens`
   - Tambahkan `BottomNavigationBarItem` baru

### 3. Mengubah Warna Tema
Edit `lib/main.dart` pada bagian `ThemeData`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Ubah warna di sini
  primary: Colors.blue,
  secondary: Colors.white,
),
```

### 4. Navigasi Antar Screen
Gunakan `AppRouter` untuk navigasi:
```dart
// Navigate ke screen lain
AppRouter.navigateTo(context, AppRouter.search);

// Navigate dan replace
AppRouter.navigateAndReplace(context, AppRouter.profile);

// Kembali
AppRouter.goBack(context);
```

## 📝 Catatan

- **IndexedStack**: Digunakan untuk maintain state setiap tab
- **State Management**: Basic setState (bisa diupgrade ke Provider/Bloc)
- **Routing**: Named routes dengan custom router
- **Bahasa**: Template menggunakan Bahasa Indonesia

## 🔧 Customisasi

Anda dapat mengcustomize:
- Warna theme
- Icon untuk setiap tab
- Label tab
- Menambah/mengurangi jumlah tab
- Styling untuk setiap screen
- Menambah widgets reusable di folder `widgets/`

## 📚 Struktur File yang Direkomendasikan

Untuk pengembangan lebih lanjut, struktur yang direkomendasikan:

```
lib/
├── main.dart
├── navigation/
│   ├── bottom_nav_bar.dart
│   └── app_router.dart
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/              # Widgets khusus home
│   ├── search/
│   │   ├── search_screen.dart
│   │   └── widgets/              # Widgets khusus search
│   └── profile/
│       ├── profile_screen.dart
│       └── widgets/              # Widgets khusus profile
├── widgets/                      # Shared widgets
│   ├── custom_button.dart
│   ├── custom_card.dart
│   └── loading_indicator.dart
├── models/                       # Data models
├── services/                     # API services
└── utils/                        # Utilities & helpers
```

## ✅ Checklist Implementasi

- [x] Struktur folder navigation
- [x] Struktur folder screens (3 tabs)
- [x] Bottom Navigation Bar
- [x] App Router
- [x] Home Screen template
- [x] Search Screen template
- [x] Profile Screen template
- [x] Tema Indonesia (Merah & Putih)
- [x] Material 3 design
- [ ] State management (Optional)
- [ ] API integration (Optional)
- [ ] Custom widgets (Optional)

---
**Dibuat untuk**: Flutter Tabs Navigator
**Tema**: Indonesia (Merah & Putih)
**Tanggal**: 2025-11-24

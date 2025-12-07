# IslamMy

IslamMy adalah aplikasi pendamping Islami yang komprehensif, dirancang untuk memudahkan ibadah sehari-hari umat Muslim. Aplikasi ini menyediakan fitur-fitur penting seperti jadwal sholat akurat, penunjuk arah kiblat, dan tasbih digital dengan antarmuka yang modern dan mudah digunakan.

## Fitur Utama

*   **Jadwal Sholat Akurat**: Menampilkan waktu sholat 5 waktu berdasarkan lokasi geografis pengguna secara real-time.
*   **Arah Kiblat**: Kompas digital presisi yang membantu pengguna menemukan arah kiblat (Ka'bah) di mana saja menggunakan sensor perangkat.
*   **Tasbih Digital**: Fitur penghitung dzikir digital yang praktis untuk menemani ibadah harian Anda.
*   **Antarmuka Modern**: Desain UI yang bersih, intuitif, dan responsif untuk pengalaman pengguna yang nyaman.

## Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan teknologi open-source modern:

*   **[Flutter](https://flutter.dev/)**: Framework UI toolkit dari Google untuk membangun aplikasi native yang indah.
*   **[Dart](https://dart.dev/)**: Bahasa pemrograman yang optimalkan untuk UI.
*   **[Geolocator](https://pub.dev/packages/geolocator)**: Untuk mengakses layanan lokasi GPS guna perhitungan waktu sholat.
*   **[Flutter Compass](https://pub.dev/packages/flutter_compass)**: Mengakses sensor kompas perangkat untuk fitur arah kiblat.
*   **[Intl](https://pub.dev/packages/intl)**: Fasilitas internasionalisasi dan lokalisasi, termasuk format tanggal dan waktu.

## Prasyarat Instalasi

Sebelum memulai, pastikan lingkungan pengembangan Anda telah memenuhi syarat berikut:

1.  **Flutter SDK**: Versi 3.0.0 atau lebih baru.
2.  **Dart SDK**: Biasanya sudah termasuk dalam instalasi Flutter.
3.  **IDE**: VS Code, Android Studio, atau editor pilihan Anda.
4.  **Perangkat**: Emulator Android/iOS atau perangkat fisik dengan sensor GPS dan Kompas (untuk fitur Kiblat).

### Langkah Instalasi

1.  **Clone Repository**
    ```bash
    git clone https://github.com/kdandy/IslamMy.git
    cd IslamMy
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## Susunan Project

Berikut adalah struktur direktori utama dari source code aplikasi:

```
lib/
├── main.dart           # Titik masuk (entry point) aplikasi
├── models/             # Definisi model data
├── navigation/         # Konfigurasi routing dan navigasi bawah (bottom bar)
├── screens/            # Halaman-halaman antarmuka pengguna
│   ├── home/           # Halaman utama dan tampilan jadwal sholat
│   ├── qibla/          # Halaman kompas penunjuk arah kiblat
│   └── tasbih/         # Halaman penghitung tasbih digital
└── services/           # Logika bisnis dan layanan eksternal (misal: lokasi)
```

## Contoh Penggunaan

1.  **Melihat Jadwal Sholat**:
    *   Buka aplikasi.
    *   Izinkan akses lokasi saat diminta.
    *   Halaman utama akan menampilkan jadwal sholat untuk lokasi Anda saat ini.

2.  **Mencari Arah Kiblat**:
    *   Ketuk ikon navigasi "Kiblat" atau "Qibla".
    *   Pegang perangkat secara datar (horizontal).
    *   Ikuti arah jarum kompas yang menunjuk ke gambar Ka'bah.

3.  **Menggunakan Tasbih**:
    *   Ketuk ikon navigasi "Tasbih".
    *   Ketuk area tengah layar untuk menambah hitungan dzikir.
    *   Gunakan tombol reset untuk mengembalikan hitungan ke nol.

## Lisensi

Proyek ini didistribusikan di bawah lisensi **MIT**.

```text
MIT License

Copyright (c) 2025 IslamMy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

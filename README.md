<div align="center">

  <img src="assets/images/logo.png" alt="Adzanku Logo" width="140" height="140" />

  # 🕌 Adzanku (أَذَانُكِي)
  ### Professional Islamic Prayer Times & Smart Azan Alarm Mobile Application

  [![Flutter](https://img.shields.io/badge/Flutter-v3.29.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-v3.7.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Android](https://img.shields.io/badge/Android-API%2023%2B-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
  [![License](https://img.shields.io/badge/License-MIT-gold?style=for-the-badge)](LICENSE)
  [![Created by](https://img.shields.io/badge/Created_by-Digitalera-0F5A47?style=for-the-badge)](https://github.com/digitalera)

  **Adzanku** adalah aplikasi mobile Flutter kelas profesional dengan desain **Light Glassmorphism** modern yang menyajikan jadwal waktu sholat akurat berbasis GPS lokasi user, alarm Azan otomatis dengan dual kategori (*Azan Subuh & Azan Reguler*), upload audio kustom, layar penuh Azan berkumandang, serta fitur Tasbih digital interaktif.

</div>

---

## 🌟 Fitur Utama (Key Features)

### ☀️ 1. Busur Waktu Sholat Interaktif (*Celestial Solar Arc*)
- **Celestial Solar Wheel**: Visualisasi lintasan matahari & bulan sepanjang hari secara dinamis.
- **Node Sholat Interaktif**: Pilih dan klik waktu sholat (Subuh, Terbit, Dzuhur, Ashar, Maghrib, Isya) untuk melihat detail jam dan hitung mundur (*countdown*) yang presisi.

### 🔊 2. Dual Kategori Suara Azan (Subuh vs Reguler)
- **Pre-installed Audio Assets**: Seluruh nada azan default berasal dari file MP3 resolusi tinggi yang langsung terpasang di dalam aplikasi (`assets/sounds/`):
  - 🌅 **Azan Subuh**: *Azan Subuh Makkah Al-Mukarramah* & *Azan Subuh Madinah Al-Munawwarah* (dengan lafaz *"As-salatu khayrum minan-nawm"*).
  - 🕌 **Azan Reguler**: *Azan Reguler Makkah Al-Mukarramah* & *Azan Reguler Mesir*.
- **Set Default Terpisah**: Tentukan nada default khusus untuk sholat Subuh dan nada default terpisah untuk sholat Reguler (Dzuhur - Isya).
- **Upload Audio Kustom**: User dapat memasukkan file audio sendiri (`.mp3`, `.wav`, `.m4a`) dari galeri HP dan mengelompokkannya sesuai kategori.

### 🔔 3. Layar Azan Berkumandang Penuh (*Full-Screen Azan Overlay*)
- **Tampilan Khusus Layar Penuh**: Ketika waktu sholat tiba, tampilan UI penuh muncul otomatis dengan animasi *pulse ring* dan kaligrafi Arab *"اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ"*.
- **Tombol Merah "HENTIKAN AZAN"**: Menghentikan pemutaran nada alarm azan seketika.
- **Tombol Snooze**: Pengingat alarm 5 menit kemudian.

### 📍 4. GPS & Integrasi Aladhan Free API
- Deteksi lokasi GPS otomatis secara presisi menggunakan `geolocator` & reverse geocoding.
- Penyesuaian metode perhitungan jadwal sholat (Kemenag RI, MWL, ISNA, Umm Al-Qura, dll).
- Tanggal Hijriah otomatis terintegrasi.

### 📿 5. Tasbih Digital & Personal Greeting
- **Personalized Header**: Sapaan ramah *"Assalamu'alaikum, [Nama User]"* dengan fitur edit nama cepat.
- **Tasbih Digital**: Counter zikir interaktif dengan respon vibrasi & animasi lingkaran transparan.

---

## 🛠️ Teknologi & Packages (Tech Stack)

| Kategori | Teknologi / Package | Kegunaan |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart 3) | Cross-Platform Mobile Development |
| **Architecture** | Provider State Management | Reactive State & Clean Architecture |
| **Audio Engine** | `audioplayers` | Pemutaran Audio Azan Asset & Device Files |
| **Notifications** | `flutter_local_notifications` | Alarm & Notifikasi Jadwal Sholat Native |
| **GPS Location** | `geolocator` & `geocoding` | Lokasi GPS Lat/Long & Reverse Geocoding Nama Kota |
| **Storage** | `shared_preferences` & `path_provider` | Penyimpanan Preferensi User & Disk Audio Storage |
| **File Picker** | `file_picker` | Upload File Audio Azan Kustom dari Galeri |
| **UI & Launcher** | `google_fonts` & `flutter_launcher_icons` | Tipografi PlusJakartaSans/Amiri & Automated App Icons |

---

## 📁 Struktur Direktori Project

```text
adzanku/
├── android/                   # Konfigurasi Native Android (id.digitalera.adzanku)
├── assets/
│   ├── images/
│   │   └── logo.png           # Logo 3D Resmi Adzanku
│   └── sounds/                # File Audio Azan MP3 Pra-Terpasang
│       ├── adzan_fajr_mekah.mp3
│       ├── adzan_fajr_madinah.mp3
│       ├── adzan_mekah.mp3
│       └── adzan_mesir.mp3
├── lib/
│   ├── models/                # Data Models (PrayerTiming, AzanSound)
│   ├── providers/             # State Management Providers (User, Prayer, Sound, Tasbih)
│   ├── screens/               # App Screens (Splash, Home, SoundCenter, Tasbih, Settings, AzanAlarm)
│   ├── services/              # API & Service Layer (Location, Prayer, Sound, Notification, User)
│   ├── theme/                 # App Theme Tokens (Light Glassmorphism Style)
│   ├── widgets/               # Reusable Glassmorphism UI Components
│   └── main.dart              # Application Entry Point
├── pubspec.yaml               # Flutter Dependencies & Assets Configuration
└── README.md                  # Dokumentasi Project
```

---

## 🚀 Panduan Memulai (Getting Started)

### Prasyarat
- Flutter SDK (v3.29.0 atau yang terbaru)
- Android Studio / VS Code dengan Ekstensi Flutter & Dart
- Android Emulator atau HP Android fisik (Min SDK 23 / Android 6.0+)

### Langkah Instalasi & Jalankan

1. **Clone Repository**
   ```bash
   git clone https://github.com/digitalera/adzanku.git
   cd adzanku
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Launcher Icons**
   ```bash
   dart run flutter_launcher_icons
   ```

4. **Jalankan di Android Emulator / Perangkat Fisik**
   ```bash
   flutter run
   ```

5. **Build APK Release (Siap Rilis)**
   ```bash
   flutter build apk --release
   ```
   *File APK release akan berada di `build/app/outputs/flutter-apk/app-release.apk`.*

---

## 📄 License & Credits

Proyek ini dikembangkan secara profesional dan dirilis di bawah lisensi MIT.

- **Developer / Author**: **Digitalera** (`id.digitalera.adzanku`)
- **API Provider**: [Aladhan Free Prayer Times API](https://aladhan.com)
- **App Name**: **Adzanku** (أَذَانُكِي)

---

<div align="center">
  <sub>Created with ❤️ by <b>Digitalera</b> for the Global Ummah.</sub>
</div>

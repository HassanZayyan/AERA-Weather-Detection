# 🌤️ AERA - AI Weather Recognition Assistant

**AERA** (AI Weather Recognition Assistant) adalah aplikasi Flutter modern yang menggunakan teknologi TensorFlow Lite untuk mendeteksi kondisi cuaca dari foto dengan akurasi tinggi. Aplikasi ini menampilkan **UI glassmorphism** yang elegan dan dapat menganalisis gambar untuk mengidentifikasi 4 jenis kondisi cuaca dengan presisi tinggi.

## ✨ Fitur Utama

- 🎨 **Glassmorphism UI** - Desain glass transparan ultra-modern dengan blur effects
- 🚀 **Splash Screen** - Animasi loading yang menawan dengan branding AERA
- 🤖 **AI Recognition** - Deteksi cuaca menggunakan TensorFlow Lite INT8
- 📸 **Camera Integration** - Ambil foto langsung atau pilih dari galeri
- 🎯 **Real-time Prediction** - Hasil prediksi instan dengan confidence score
- 💡 **Smart Advice** - Saran aktivitas berdasarkan kondisi cuaca
- 🎭 **Advanced Animations** - Pulse, fade, scale, dan rotate animations
- 📱 **Responsive Design** - Tampilan optimal untuk semua ukuran layar

## 🌈 Kondisi Cuaca yang Didukung

| Kondisi | Icon | Deskripsi Indonesia | Advice |
|---------|------|---------------------|---------|
| **Sunrise** | 🌅 | Matahari Terbit | Waktu yang indah untuk foto pemandangan! |
| **Shine** | ☀️ | Cerah | Cuaca bagus untuk aktivitas outdoor |
| **Cloud** | ☁️ | Berawan | Bawa payung untuk jaga-jaga |
| **Rain** | 🌧️ | Hujan | Gunakan jas hujan jika keluar rumah |

## 🎨 Design System

### 🔮 Glassmorphism Features
- **Background**: Dark gradient dengan tema gelap
- **Glass Elements**: BackdropFilter dengan blur effects
- **Borders**: Rounded borders dengan opacity gradients
- **Typography**: SF Pro Display sebagai font utama
- **Animations**: Multiple animations untuk pengalaman premium

### 🎪 Splash Screen
- **Animations**: Kombinasi fade, scale, pulse, dan rotate animations
- **Typography**: AERA branding dengan tampilan elegant
- **Loading**: Smooth transitions selama loading model AI
- **Duration**: Sequence animations untuk user experience yang optimal

## 🚀 Cara Menggunakan

### 📋 Prasyarat

- **Flutter SDK** versi 3.5.3 atau lebih baru
- **Android Studio** atau **VS Code** dengan Flutter plugin
- **Android device** dengan API level 21+ atau **iOS device** dengan iOS 11+
- **RAM minimum** 2GB untuk performa optimal

### 📦 Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/yourusername/AERA-Weather-Detection.git
   cd AERA-Weather-Detection
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verifikasi model AI**
   - Pastikan file `weather_int8.tflite` ada di `assets/models/`
   - File size: ~6.8MB

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

### 🎯 Cara Penggunaan

1. **Splash Screen** - Nikmati animasi loading AERA yang menawan
2. **Status Check** - Tunggu status "Model AI Siap" 
3. **Ambil foto cuaca:**
   - 📸 **Tombol Kamera Utama**: Ambil foto dengan kamera
   - 🖼️ **Tombol Galeri**: Pilih foto dari galeri
4. **Lihat hasil** - Aplikasi akan menampilkan:
   - Jenis cuaca terdeteksi dengan deskripsi
   - Confidence score
   - Saran aktivitas berdasarkan cuaca

## 💡 Tips untuk Hasil Terbaik

### ✅ Rekomendasi
- Fokuskan kamera pada **langit** yang luas (minimal 60% frame)
- Ambil foto saat **pencahayaan natural** yang cukup
- Pastikan **kondisi cuaca jelas** terlihat
- Gunakan foto dengan **resolusi tinggi**
- Hindari foto dengan banyak **objek penghalang**

### ❌ Hindari
- Foto yang didominasi gedung/pohon/gunung
- Foto dalam ruangan atau malam hari
- Foto yang terlalu gelap, blur, atau overexposed
- Close-up objek yang bukan langit
- Foto dengan filter atau editing berlebihan

## 🛠️ Struktur Aplikasi

```
lib/
├── main.dart                 # Entry point dengan AERA branding
├── splash_screen.dart        # Animated splash screen
├── modern_weather_ui.dart    # Glassmorphism UI & camera integration
├── weather_model.dart        # AI model dan prediction logic

assets/
├── icons/
│   └── app_icon.png          # Application icon
└── models/
    └── weather_int8.tflite   # TensorFlow Lite model
```

## 🔧 Troubleshooting

### ⚠️ Model tidak dapat dimuat
**Gejala:** Error pada saat loading model

**Solusi:**
- ✅ Cek file `assets/models/weather_int8.tflite` ada dan utuh
- ✅ Pastikan file tercantum di pubspec.yaml pada bagian assets
- ✅ Jalankan `flutter clean && flutter pub get`
- ✅ Restart aplikasi 

### ⚠️ Prediksi tidak akurat
**Gejala:** Hasil prediksi tidak sesuai dengan kondisi cuaca

**Solusi:**
- ✅ Periksa urutan label di `weather_model.dart`
- ✅ Coba dengan gambar cuaca yang lebih jelas
- ✅ Verifikasi permissions kamera dan storage

### ⚠️ Kamera tidak berfungsi
**Gejala:** Tidak dapat mengakses kamera

**Solusi:**
- ✅ Periksa permission_handler sudah diimplementasi
- ✅ Pastikan manifest Android dan Info.plist iOS sudah dikonfigurasi
- ✅ Coba restart aplikasi atau device

## 📊 Spesifikasi Model AI

- **Framework:** TensorFlow Lite
- **Quantization:** INT8 untuk performa optimal
- **Input Shape:** [1, 224, 224, 3] (NHWC format)
- **Output Shape:** [1, 4] (4 weather classes)
- **Labels:** Cloud, Rain, Shine, Sunrise
- **Confidence Threshold:** 50% (default)
- **Preprocessing:** Normalization dengan mean=127.5, std=127.5

## 🎨 Filosofi Desain

AERA menggunakan **Glassmorphism Design Language** dengan:
- **Colors**: Purple gradient (#6C5CE7) dengan dark theme
- **Transparency**: Multi-layer opacity untuk depth
- **Blur**: BackdropFilter untuk glass effect
- **Typography**: SF Pro Display 
- **Animations**: Fluid dan purposeful animations

## 🚀 Optimisasi Performa

- **Lazy Loading**: Model dimuat saat splash screen
- **Image Optimization**: Auto-resize gambar
- **Memory Management**: Proper disposal animasi controllers
- **Async Processing**: Non-blocking UI untuk AI inference

## 📱 Dukungan Platform

- ✅ **Android** (API 21+)
- ✅ **Phone & Tablet** - Responsive design

## 🎯 Roadmap Pengembangan

### 🔜 Fitur Mendatang
- [ ] Weather history tracking
- [ ] Weather location mapping
- [ ] Dark/Light theme toggle
- [ ] Export prediction results

## 👥 Tim Pengembang

**AERA** dikembangkan dengan oleh:
- **Ardan Ferdiansah** 
- **Muhammad Hassan Naufal Zayyan**

## 🛠️ Teknologi yang Digunakan

- **Flutter Framework** - Cross-platform mobile development
- **TensorFlow Lite** - On-device machine learning
- **Material Design 3** - Modern UI components
- **SF Pro Display** - Premium typography

## 📄 Lisensi

Proyek ini dilisensikan di bawah **MIT License** - silakan gunakan dan modifikasi sesuai kebutuhan.

Lihat file [LICENSE](LICENSE) untuk detail lengkap.

## 🤝 Kontribusi

Kami menyambut kontribusi dari komunitas! Silakan:

1. Fork repository ini
2. Buat branch untuk fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

**✨ Rasakan masa depan pengenalan cuaca dengan antarmuka glassmorphism AERA yang memukau!**

**🎯 Best Practice:** Jalankan dalam release mode untuk performa optimal: `flutter run --release`

**⭐ Jika proyek ini bermanfaat, jangan lupa berikan star di GitHub!**
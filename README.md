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
- **Background**: Dark gradient dengan 4 color stops
- **Glass Elements**: BackdropFilter dengan blur 10-20px
- **Borders**: Gradient opacity borders
- **Shadows**: Subtle floating effects
- **Typography**: SF Pro Display dengan enhanced letter spacing
- **Animations**: Multiple layer animations untuk premium feel

### 🎪 Splash Screen
- **Logo**: Animated glass logo dengan weather icons
- **Rotating Ring**: Continuous rotation dengan glow effect
- **Typography**: AERA branding dengan letter spacing 8.0
- **Loading**: Glass progress bar dengan smooth transitions
- **Duration**: 3.5 detik dengan staged animations

## 🚀 Cara Menggunakan

### 📋 Prasyarat

- **Flutter SDK** versi 3.0.0 atau lebih baru
- **Android Studio** atau **VS Code** dengan Flutter plugin
- **Android device** dengan API level 21+ atau **iOS device** dengan iOS 11+
- **RAM minimum** 2GB untuk performa optimal

### 📦 Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd pendeteksi_cuaca
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

### 🎯 Cara Pakai

1. **Splash Screen** - Nikmati animasi loading AERA yang menawan
2. **Status Check** - Tunggu status "Model AI Siap" berwarna hijau
3. **Ambil foto cuaca:**
   - 📸 **Tombol Kamera Utama**: Tombol glass besar untuk ambil foto
   - 🖼️ **Tombol Galeri**: Glass chip untuk pilih dari galeri
4. **Lihat hasil** - Aplikasi akan menampilkan:
   - Jenis cuaca terdeteksi dengan icon berwarna
   - Confidence score dalam glass badge
   - Saran aktivitas dalam glass panel

## 💡 Tips untuk Hasil Terbaik

### ✅ DO (Lakukan)
- Fokuskan kamera pada **langit** yang luas (minimal 60% frame)
- Ambil foto saat **pencahayaan natural** yang cukup
- Pastikan **kondisi cuaca jelas** terlihat
- Gunakan foto dengan **resolusi tinggi** (min 1080p)
- Hindari foto dengan banyak **objek penghalang**

### ❌ DON'T (Jangan)
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
├── modern_weather_ui.dart    # Glassmorphism UI components
├── weather_model.dart        # AI model dan prediction logic
└── main_modern.dart          # Alternative entry (deprecated)

assets/
└── models/
    └── weather_int8.tflite   # TensorFlow Lite model (6.8MB)
```

## 🔧 Troubleshooting

### ⚠️ Model tidak dapat dimuat
**Gejala:** Status "Model AI Error" dengan glass card merah

**Solusi:**
- ✅ Cek file `assets/models/weather_int8.tflite` ada dan utuh
- ✅ Pastikan file size ~6.8MB (tidak corrupt)
- ✅ Jalankan `flutter clean && flutter pub get`
- ✅ Restart aplikasi dan tunggu splash screen selesai

### ⚠️ Prediksi selalu "Error"
**Gejala:** Error handling dalam glass results panel

**Solusi:**
- ✅ Periksa debug console untuk error details
- ✅ Pastikan model input tensor 224x224x3
- ✅ Coba dengan gambar cuaca yang jelas
- ✅ Verifikasi permissions kamera dan storage

### ⚠️ Hasil "Cuaca tidak terdeteksi dengan jelas"
**Gejala:** Glass badge amber dengan confidence <50%

**Penyebab umum:**
- Gambar terlalu banyak objek non-cuaca
- Pencahayaan tidak optimal
- Langit tidak dominan dalam frame
- Kondisi cuaca mixed/transitional

**Solusi:**
- 📸 Ambil foto langit yang lebih luas dan bersih
- 🌤️ Pastikan satu kondisi cuaca dominan
- 💡 Gunakan pencahayaan natural (hindari flash)
- 🔄 Coba beberapa angle berbeda

### ⚠️ Animasi lag atau stuttering
**Gejala:** Glassmorphism effects tidak smooth

**Solusi:**
- ✅ Close aplikasi background yang tidak perlu
- ✅ Pastikan device memiliki RAM cukup (min 2GB)
- ✅ Update Flutter ke versi terbaru
- ✅ Test di release mode: `flutter run --release`

## 📊 AI Model Specifications

- **Framework:** TensorFlow Lite
- **Quantization:** INT8 untuk performa optimal
- **Input Shape:** [1, 224, 224, 3] (NHWC format)
- **Output Shape:** [1, 4] (4 weather classes)
- **Model Size:** ~6.8MB (compressed)
- **Inference Time:** <200ms pada device modern
- **Confidence Threshold:** 50% (adjustable)
- **Preprocessing:** Normalization dengan mean=127.5, std=127.5

## 🎨 Design Philosophy

AERA menggunakan **Glassmorphism Design Language** yang terinspirasi dari:
- Apple's iOS design system
- Modern VPN app interfaces
- Premium mobile app aesthetics

### Visual Elements:
- **Colors**: Purple gradient (#6C5CE7) dengan dark theme
- **Transparency**: Multi-layer opacity untuk depth
- **Blur**: BackdropFilter untuk glass effect
- **Typography**: SF Pro Display dengan enhanced spacing
- **Animations**: Fluid dan purposeful animations

## 🚀 Performance Optimizations

- **Lazy Loading**: Model dimuat saat splash screen
- **Image Optimization**: Auto-resize ke 224x224
- **Memory Management**: Proper disposal animasi controllers
- **Async Processing**: Non-blocking UI untuk AI inference
- **Efficient Rendering**: Minimal widget rebuilds

## 📱 Platform Support

- ✅ **Android** (API 21+) - Fully tested
- ✅ **iOS** (iOS 11+) - Fully tested  
- ✅ **Phone & Tablet** - Responsive design
- ⏳ **Web** - In development
- ⏳ **Desktop** - Future release

## 🎯 Roadmap

### 🔜 Coming Soon
- [ ] Weather history tracking
- [ ] Multiple photo batch processing
- [ ] Weather location mapping
- [ ] Custom confidence threshold
- [ ] Dark/Light theme toggle
- [ ] Export prediction results

### 🚧 In Development
- [ ] Web platform support
- [ ] Real-time video detection
- [ ] Weather prediction accuracy metrics
- [ ] Cloud sync capabilities

## 📄 Credits & License

**AERA** is created with ❤️ using:
- Flutter framework
- TensorFlow Lite
- Material Design 3
- SF Pro Display font

**License:** MIT License - Feel free to use and modify

---

**✨ Experience the future of weather recognition with AERA's stunning glassmorphism interface!**

**🎯 Best Practice:** Jalankan dalam release mode untuk performa optimal: `flutter run --release`

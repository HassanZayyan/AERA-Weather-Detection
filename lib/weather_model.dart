import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';

class WeatherModel {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  
  // Labels cuaca - disesuaikan dengan 4 kondisi cuaca yang tersedia
  // PENTING: Urutan ini HARUS SAMA dengan urutan saat training model!
  // KEMUNGKINAN URUTAN DARI TRAINING (perlu diverifikasi):
  // Index 0: Cloud
  // Index 1: Rain
  // Index 2: Shine  
  // Index 3: Sunrise
  final List<String> _weatherLabels = [
    'Cloud',
    'Rain', 
    'Shine',
    'Sunrise'
  ];
  
  // Alternative label orders untuk testing
  // Jika prediksi tidak akurat, coba ganti dengan salah satu urutan ini
  final List<List<String>> _alternativeLabelOrders = [
    ['Cloud', 'Rain', 'Shine', 'Sunrise'],  // Alphabetical
    ['Rain', 'Cloud', 'Shine', 'Sunrise'],  // Alternative 1
    ['Shine', 'Sunrise', 'Cloud', 'Rain'],  // Alternative 2
    ['Cloud', 'Shine', 'Sunrise', 'Rain'],  // Alternative 3
  ];
  
  // Deskripsi cuaca dalam bahasa Indonesia
  final Map<String, String> _weatherDescriptions = {
    'Sunrise': 'Matahari Terbit',
    'Shine': 'Cerah',
    'Cloud': 'Berawan',
    'Rain': 'Hujan',
  };
  
  // Saran aktivitas berdasarkan cuaca
  final Map<String, String> _weatherAdvice = {
    'Sunrise': 'Waktu yang indah untuk foto pemandangan!',
    'Shine': 'Cuaca bagus untuk aktivitas outdoor',
    'Cloud': 'Bawa payung untuk jaga-jaga',
    'Rain': 'Gunakan jas hujan jika keluar rumah',
  };
  
  // Ukuran input model
  static const int inputSize = 224;
  static const double mean = 127.5;
  static const double std = 127.5;
  
  // Quantization parameters untuk int8 models
  static const double scale = 0.0078125; // 1/128
  static const int zeroPoint = 128;
  
  // Threshold confidence minimum
  static const double minConfidenceThreshold = 50.0;

  bool get isModelLoaded => _isModelLoaded;
  List<String> get weatherLabels => _weatherLabels;

  /// Memuat model TensorFlow Lite
  Future<bool> loadModel() async {
    try {
      debugPrint('=== LOADING MODEL ===');
      debugPrint('Attempting to load model from: assets/models/weather_int8.tflite');
      
      // Try to load model - tflite_flutter expects path without 'assets/' prefix
      try {
        _interpreter = await Interpreter.fromAsset('models/weather_int8.tflite');
        debugPrint('Model loaded successfully from: models/weather_int8.tflite');
      } catch (e) {
        debugPrint('Failed to load from models/weather_int8.tflite: $e');
        // Fallback to full path
        _interpreter = await Interpreter.fromAsset('assets/models/weather_int8.tflite');
        debugPrint('Model loaded successfully from: assets/models/weather_int8.tflite');
      }
      
      // Alokasikan tensor agar kita bisa mendapatkan informasi bentuk dan tipe data input/output
      _interpreter!.allocateTensors();
      
      // Debug informasi model
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);
      
      debugPrint('=== MODEL INFO ===');
      debugPrint('Input tensor shape: ${inputTensor.shape}');
      debugPrint('Input tensor type: ${inputTensor.type}');
      debugPrint('Output tensor shape: ${outputTensor.shape}');
      debugPrint('Output tensor type: ${outputTensor.type}');
      debugPrint('=================');
      
      _isModelLoaded = true;
      debugPrint('Model successfully loaded and ready for inference');
      return true;
    } catch (e) {
      debugPrint('=== MODEL LOADING FAILED ===');
      debugPrint('Error: $e');
      _isModelLoaded = false;
      return false;
    }
  }

  /// Melakukan prediksi cuaca dari gambar
  Future<Map<String, dynamic>> predictWeather(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      return {
        'success': false,
        'error': 'Model belum dimuat'
      };
    }

    try {
      debugPrint('Memulai prediksi cuaca...');
      
      // Baca dan preprocess gambar
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        return {
          'success': false,
          'error': 'Gagal membaca gambar'
        };
      }

      debugPrint('Gambar original: ${image.width}x${image.height}');
      
      // Resize gambar ke ukuran yang diharapkan model
      final resizedImage = img.copyResize(image, width: inputSize, height: inputSize);
      debugPrint('Gambar diresize ke: ${resizedImage.width}x${resizedImage.height}');
      
      // Konversi gambar ke tensor input sesuai tipe yang diminta model
      final input = _preprocessImage(resizedImage);
      debugPrint('Input tensor berhasil dibuat');
      
      // Siapkan output tensor dengan bentuk yang benar
      final outputTensor = _interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      final outputType = outputTensor.type;
      debugPrint('Output tensor shape: $outputShape');
      debugPrint('Output tensor type: $outputType');
      
      // Calculate total output size
      int outputSize = 1;
      for (var dim in outputShape) {
        outputSize *= dim;
      }
      debugPrint('Total output size: $outputSize');
      
      // Create output buffer based on type - use flat array
      dynamic output;
      
      if (outputType.toString().contains('uint8') || outputType == 3 || outputType == TfLiteType.kTfLiteUInt8) {
        debugPrint('Creating Uint8List output buffer with size $outputSize');
        output = Uint8List(outputSize);
      } else if (outputType.toString().contains('float32') || outputType == 1 || outputType == TfLiteType.kTfLiteFloat32) {
        debugPrint('Creating Float32List output buffer with size $outputSize');
        output = Float32List(outputSize);
      } else {
        // Default to Float32List
        debugPrint('Unknown output type, defaulting to Float32List');
        output = Float32List(outputSize);
      }
      
      debugPrint('Menjalankan inferensi...');
      
      // Debug input tensor info
      debugPrint('=== DEBUG INPUT TENSOR ===');
      debugPrint('Input type: ${input.runtimeType}');
      if (input is Uint8List) {
        debugPrint('Input length: ${input.length}');
        // Sample first few pixels
        debugPrint('First 12 values (first 4 pixels RGB): ${input.take(12).toList()}');
      } else if (input is Float32List) {
        debugPrint('Input length: ${input.length}');
        debugPrint('First 12 values (first 4 pixels RGB): ${input.take(12).toList()}');
      } else if (input is Int8List) {
        debugPrint('Input length: ${input.length}');
        debugPrint('First 12 values (first 4 pixels RGB): ${input.take(12).toList()}');
      }
      debugPrint('=========================');
      
      // Jalankan inferensi
      _interpreter!.run(input, output);
      
      debugPrint('Inferensi selesai');
      debugPrint('Output raw: ${output.runtimeType} - First 10 values: ${output is List ? output.take(10).toList() : (output as TypedData).buffer.asUint8List().take(10).toList()}');
      
      // Konversi output ke List<double> untuk processing
      List<double> predictions;
      
      // Output is always a flat array, we need to extract the predictions
      if (output is Uint8List) {
        // Convert uint8 (0-255) to probability (0-1)
        debugPrint('Processing Uint8List output');
        if (outputShape.length == 2 && outputShape[0] == 1) {
          // Shape [1, 4] - skip batch dimension
          predictions = output.skip(0).take(outputShape[1]).map((e) => e / 255.0).toList();
        } else if (outputShape.length == 1) {
          // Shape [4]
          predictions = output.map((e) => e / 255.0).toList();
        } else {
          // Take first 4 values
          predictions = output.take(4).map((e) => e / 255.0).toList();
        }
      } else if (output is Float32List) {
        debugPrint('Processing Float32List output');
        if (outputShape.length == 2 && outputShape[0] == 1) {
          // Shape [1, 4] - skip batch dimension
          predictions = output.skip(0).take(outputShape[1]).toList();
        } else if (outputShape.length == 1) {
          // Shape [4]
          predictions = output.toList();
        } else {
          // Take first 4 values
          predictions = output.take(4).toList();
        }
      } else {
        throw Exception('Unexpected output type: ${output.runtimeType}');
      }
      
      // Ensure we have exactly 4 predictions
      if (predictions.length != 4) {
        debugPrint('Warning: Expected 4 predictions but got ${predictions.length}');
        // Pad or truncate to 4
        if (predictions.length < 4) {
          predictions = predictions + List.filled(4 - predictions.length, 0.0);
        } else {
          predictions = predictions.take(4).toList();
        }
      }
      
      debugPrint('Raw predictions: $predictions');
      debugPrint('Predictions length: ${predictions.length}');
      
      // Normalize predictions if needed (ensure they sum to 1)
      double sum = predictions.reduce((a, b) => a + b);
      if (sum > 0 && (sum < 0.99 || sum > 1.01)) {
        debugPrint('Normalizing predictions (sum was $sum)');
        predictions = predictions.map((p) => p / sum).toList();
      }
      
      // Debug all predictions with labels
      debugPrint('=== PREDICTION DETAILS ===');
      for (int i = 0; i < predictions.length && i < _weatherLabels.length; i++) {
        debugPrint('${_weatherLabels[i]}: ${(predictions[i] * 100).toStringAsFixed(2)}%');
      }
      debugPrint('========================');
      
      final maxIndex = predictions.indexOf(predictions.reduce((a, b) => a > b ? a : b));
      final confidence = predictions[maxIndex] * 100;
      
      debugPrint('Predicted class index: $maxIndex');
      debugPrint('Predicted label: ${_weatherLabels[maxIndex]}');
      debugPrint('Confidence: $confidence%');
      
      // Cek apakah confidence kurang dari threshold minimum
      if (confidence < minConfidenceThreshold) {
        debugPrint('Confidence terlalu rendah, mengembalikan hasil non-weather');
        return {
          'success': true,
          'label': 'Cuaca tidak terdeteksi dengan jelas',
          'labelIndo': 'Cuaca tidak terdeteksi dengan jelas',
          'advice': 'Coba ambil foto langit yang lebih luas tanpa banyak objek penghalang (gedung, pohon, dll)',
          'confidence': confidence,
          'allPredictions': Map.fromIterables(_weatherLabels, predictions),
          'isWeatherScene': false
        };
      }
      
      final predictedLabel = _weatherLabels[maxIndex];
      final predictedLabelIndo = _weatherDescriptions[predictedLabel] ?? predictedLabel;
      final advice = _weatherAdvice[predictedLabel] ?? '';
      debugPrint('Predicted weather: $predictedLabel ($predictedLabelIndo)');
      
      return {
        'success': true,
        'label': predictedLabel,
        'labelIndo': predictedLabelIndo,
        'advice': advice,
        'confidence': confidence,
        'allPredictions': Map.fromIterables(_weatherLabels, predictions),
        'isWeatherScene': true
      };
      
    } catch (e, stackTrace) {
      debugPrint('Error saat prediksi: $e');
      debugPrint('Stack trace: $stackTrace');
      return {
        'success': false,
        'error': 'Error dalam prediksi: $e'
      };
    }
  }

  /// Preprocess image into input tensor with correct data type (float32, uint8, int8)
  dynamic _preprocessImage(img.Image image) {
    if (_interpreter == null) {
      throw Exception('Interpreter is null');
    }
    
    Tensor? inputTensor;
    try {
      inputTensor = _interpreter!.getInputTensor(0);
    } catch (e) {
      debugPrint('Error getting input tensor: $e');
      throw Exception('Failed to get input tensor: $e');
    }
    
    if (inputTensor == null) {
      throw Exception('Input tensor is null');
    }
    
    final dataType = inputTensor.type;
    final shape = inputTensor.shape; // [1, height, width, channels]
    
    if (shape == null || shape.length < 3) {
      throw Exception('Invalid input tensor shape: $shape');
    }

    final height = shape[1];
    final width = shape[2];
    final channels = shape.length > 3 ? shape[3] : 3; // Default to 3 channels if not specified
    
    debugPrint('Input tensor dataType value: $dataType');
    debugPrint('TfLiteType constants - Float32: ${TfLiteType.kTfLiteFloat32}, UInt8: ${TfLiteType.kTfLiteUInt8}, Int8: ${TfLiteType.kTfLiteInt8}');
    debugPrint('Shape details - height: $height, width: $width, channels: $channels');

    assert(height == inputSize && width == inputSize && channels == 3,
        'Ukuran tensor input tidak sesuai dengan yang diharapkan. Expected: ${inputSize}x${inputSize}x3, Got: ${height}x${width}x${channels}');

    // Check against the actual TfLiteType values
    if (dataType == TfLiteType.kTfLiteFloat32 || dataType.toString() == 'float32' || dataType == 1) {
      debugPrint('Model uses FLOAT32 input');
      // Gunakan Float32List flat untuk tflite_flutter
      final Float32List input = Float32List(1 * height * width * channels);
      int pixelIndex = 0;
      
      // Format: [batch][y][x][c] dalam array flat
      for (int batch = 0; batch < 1; batch++) {
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            final pixel = image.getPixel(x, y);
            // Access RGB values using pixel properties
            input[pixelIndex++] = (pixel.r - mean) / std;
            input[pixelIndex++] = (pixel.g - mean) / std;
            input[pixelIndex++] = (pixel.b - mean) / std;
          }
        }
      }
      return input;
      
    } else if (dataType == TfLiteType.kTfLiteUInt8 || dataType.toString() == 'uint8' || dataType == 3) {
      debugPrint('Model uses UINT8 input');
      // Gunakan Uint8List flat untuk tflite_flutter
      final Uint8List input = Uint8List(1 * height * width * channels);
      int pixelIndex = 0;
      
      for (int batch = 0; batch < 1; batch++) {
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            final pixel = image.getPixel(x, y);
            // Direct pixel values (0-255) for uint8
            input[pixelIndex++] = pixel.r.toInt().clamp(0, 255);
            input[pixelIndex++] = pixel.g.toInt().clamp(0, 255);
            input[pixelIndex++] = pixel.b.toInt().clamp(0, 255);
          }
        }
      }
      return input;
      
    } else if (dataType == TfLiteType.kTfLiteInt8 || dataType.toString() == 'int8' || dataType == 9) {
      debugPrint('Model uses INT8 input');
      // Gunakan Int8List flat untuk tflite_flutter
      final Int8List input = Int8List(1 * height * width * channels);
      int pixelIndex = 0;
      
      for (int batch = 0; batch < 1; batch++) {
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            final pixel = image.getPixel(x, y);
            // Quantization formula untuk int8: q = round(r/scale) - zeroPoint
            // Untuk model yang dilatih dengan normalisasi standar: (pixel - 128)
            input[pixelIndex++] = (pixel.r.toInt() - 128).clamp(-128, 127);
            input[pixelIndex++] = (pixel.g.toInt() - 128).clamp(-128, 127);
            input[pixelIndex++] = (pixel.b.toInt() - 128).clamp(-128, 127);
          }
        }
      }
      return input;
      
    } else {
      // Fallback with numeric values
      debugPrint('Unknown dataType: $dataType, trying numeric fallback...');
      
      // TensorFlow Lite type constants (numeric values)
      const int TFLITE_FLOAT32 = 1;
      const int TFLITE_INT32 = 2;
      const int TFLITE_UINT8 = 3;
      const int TFLITE_INT64 = 4;
      const int TFLITE_STRING = 5;
      const int TFLITE_BOOL = 6;
      const int TFLITE_INT16 = 7;
      const int TFLITE_COMPLEX64 = 8;
      const int TFLITE_INT8 = 9;
      
      switch (dataType) {
        case TFLITE_FLOAT32: // 1
          // Gunakan Float32List flat untuk tflite_flutter
          final Float32List input = Float32List(1 * height * width * channels);
          int pixelIndex = 0;
          
          // Format: [batch][y][x][c] dalam array flat
          for (int batch = 0; batch < 1; batch++) {
            for (int y = 0; y < height; y++) {
              for (int x = 0; x < width; x++) {
                final pixel = image.getPixel(x, y);
                // Access RGB values using pixel properties
                input[pixelIndex++] = (pixel.r - mean) / std;
                input[pixelIndex++] = (pixel.g - mean) / std;
                input[pixelIndex++] = (pixel.b - mean) / std;
              }
            }
          }
          return input;

        case TFLITE_UINT8: // 3
          // Gunakan Uint8List flat untuk tflite_flutter
          final Uint8List input = Uint8List(1 * height * width * channels);
          int pixelIndex = 0;
          
          for (int batch = 0; batch < 1; batch++) {
            for (int y = 0; y < height; y++) {
              for (int x = 0; x < width; x++) {
                final pixel = image.getPixel(x, y);
                input[pixelIndex++] = pixel.r.toInt();
                input[pixelIndex++] = pixel.g.toInt();
                input[pixelIndex++] = pixel.b.toInt();
              }
            }
          }
          return input;

        case TFLITE_INT8: // 9
          // Gunakan Int8List flat untuk tflite_flutter
          final Int8List input = Int8List(1 * height * width * channels);
          int pixelIndex = 0;
          
          for (int batch = 0; batch < 1; batch++) {
            for (int y = 0; y < height; y++) {
              for (int x = 0; x < width; x++) {
                final pixel = image.getPixel(x, y);
                // Quantization formula untuk int8: q = round(r/scale) - zeroPoint
                // Untuk model yang dilatih dengan normalisasi standar: (pixel - 128)
                input[pixelIndex++] = (pixel.r.toInt() - 128).clamp(-128, 127);
                input[pixelIndex++] = (pixel.g.toInt() - 128).clamp(-128, 127);
                input[pixelIndex++] = (pixel.b.toInt() - 128).clamp(-128, 127);
              }
            }
          }
          return input;

        default:
          debugPrint('WARNING: Unexpected tensor type: $dataType');
          debugPrint('Expected one of: FLOAT32($TFLITE_FLOAT32), UINT8($TFLITE_UINT8), INT8($TFLITE_INT8)');
          
          // Fallback handling berdasarkan nama model
          if (dataType == 3 || dataType.toString().contains('uint8')) {
            debugPrint('Attempting UINT8 fallback (detected type $dataType)...');
            final Uint8List input = Uint8List(1 * height * width * channels);
            int pixelIndex = 0;
            
            for (int batch = 0; batch < 1; batch++) {
              for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                  final pixel = image.getPixel(x, y);
                  input[pixelIndex++] = pixel.r.toInt();
                  input[pixelIndex++] = pixel.g.toInt();
                  input[pixelIndex++] = pixel.b.toInt();
                }
              }
            }
            return input;
          } else if (dataType == 9 || dataType.toString().contains('int8')) {
            debugPrint('Attempting INT8 fallback (detected type $dataType)...');
            final Int8List input = Int8List(1 * height * width * channels);
            int pixelIndex = 0;
            
            for (int batch = 0; batch < 1; batch++) {
              for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                  final pixel = image.getPixel(x, y);
                  input[pixelIndex++] = (pixel.r.toInt() - 128).clamp(-128, 127);
                  input[pixelIndex++] = (pixel.g.toInt() - 128).clamp(-128, 127);
                  input[pixelIndex++] = (pixel.b.toInt() - 128).clamp(-128, 127);
                }
              }
            }
            return input;
          }
          
          throw UnsupportedError('Tipe data input $dataType belum didukung. Mohon gunakan model dengan tipe FLOAT32, UINT8, atau INT8.');
      }
    }
  }

  /// Tutup interpreter saat tidak diperlukan
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
  }
} 
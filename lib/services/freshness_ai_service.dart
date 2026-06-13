import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FreshnessResult {
  final int freshnessScore;
  final String freshnessStatus;
  final int confidenceScore;
  final String recommendation;

  FreshnessResult({
    required this.freshnessScore,
    required this.freshnessStatus,
    required this.confidenceScore,
    required this.recommendation,
  });
}

class FreshnessAiService {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/freshness_model.tflite');
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData.split('\n');
      _isInitialized = true;
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<FreshnessResult> analyzeFreshness(dynamic imageInput) async {
    if (!_isInitialized || _interpreter == null) {
      await init();
    }
    
    if (!_isInitialized) {
      return _generateFallbackResult();
    }

    try {
      img.Image? inputImage;
      
      if (imageInput is String) {
        if (imageInput.startsWith('/')) {
          // Ini adalah path file fisik dari Kamera HP
          final file = File(imageInput);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            inputImage = img.decodeImage(bytes);
          }
        } else {
          // Ini adalah path asset (untuk testing)
          final bytes = await rootBundle.load(imageInput).then((b) => b.buffer.asUint8List()).catchError((_) => Uint8List(0));
          if (bytes.isNotEmpty) {
            inputImage = img.decodeImage(bytes);
          }
        }
      } else if (imageInput is img.Image) {
        inputImage = imageInput;
      }
      
      if (inputImage == null) return _generateFallbackResult();

      // MobileNet V1 224 uses 224x224 input
      img.Image resizedImage = img.copyResize(inputImage, width: 224, height: 224);
      var inputMatrix = _imageToMatrix(resizedImage, 224);

      // Prepare output tensor [1, 12]
      var output = List.filled(1 * 12, 0.0).reshape([1, 12]);

      _interpreter!.run(inputMatrix, output);

      List<double> probabilities = (output[0] as List).cast<double>();
      
      double maxProb = 0;
      int maxIndex = 0;
      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      String detectedLabel = _labels != null && _labels!.length > maxIndex ? _labels![maxIndex] : "Unknown";
      
      int freshnessScore = 50;
      int confidence = (maxProb * 100).toInt();

      if (detectedLabel.toLowerCase().contains('fresh')) {
        // Jika terdeteksi segar, ubah nilai confidence tinggi menjadi skor kesegaran tinggi (80-98)
        freshnessScore = 80 + (maxProb * 18).toInt(); 
      } else if (detectedLabel.toLowerCase().contains('stale')) {
        // Jika terdeteksi busuk, ubah nilai confidence tinggi menjadi skor kesegaran rendah (20-50)
        freshnessScore = 50 - (maxProb * 30).toInt();
      }

      return FreshnessResult(
        freshnessScore: freshnessScore,
        freshnessStatus: _getStatus(freshnessScore),
        confidenceScore: confidence,
        recommendation: "AI Melihat: $detectedLabel. ${_getRecommendation(freshnessScore)}",
      );
    } catch (e) {
      print('Inference error: $e');
      return _generateFallbackResult();
    }
  }

  List<List<List<List<double>>>> _imageToMatrix(img.Image image, int inputSize) {
    return List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            var pixel = image.getPixelSafe(x, y);
            // Normalisasi piksel ke nilai FLOAT32 (0.0 - 1.0)
            return [pixel.r.toDouble() / 255.0, pixel.g.toDouble() / 255.0, pixel.b.toDouble() / 255.0];
          },
        ),
      ),
    );
  }

  FreshnessResult _generateFallbackResult() {
    return FreshnessResult(
      freshnessScore: 50,
      freshnessStatus: 'WARNING',
      confidenceScore: 0,
      recommendation: 'Model belum memproses gambar.',
    );
  }

  String _getStatus(int score) {
    if (score >= 80) return 'FRESH';
    if (score >= 60) return 'WARNING';
    return 'CRITICAL';
  }

  String _getRecommendation(int score) {
    if (score >= 80) return 'Kondisi sayuran sangat baik. Proses penerimaan (Accept).';
    if (score >= 60) return 'Ada beberapa yang jelek. Terima dengan catatan, lakukan sortir (Partial Accept).';
    return 'Terlalu banyak yang jelek. Direkomendasikan untuk sortir ulang atau tolak (Reject).';
  }
}

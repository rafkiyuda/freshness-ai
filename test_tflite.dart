import 'package:tflite_flutter/tflite_flutter.dart';

void main() async {
  try {
    final interpreter = await Interpreter.fromAsset('assets/models/freshness_model.tflite');
    print('Inputs:');
    for (var tensor in interpreter.getInputTensors()) {
      print('  ${tensor.name}: shape=${tensor.shape}, type=${tensor.type}');
    }
    print('Outputs:');
    for (var tensor in interpreter.getOutputTensors()) {
      print('  ${tensor.name}: shape=${tensor.shape}, type=${tensor.type}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

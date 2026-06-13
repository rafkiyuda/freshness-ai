import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Print TFLite shapes', () async {
    final interpreter = await Interpreter.fromAsset('assets/models/freshness_model.tflite');
    print('Inputs:');
    for (var tensor in interpreter.getInputTensors()) {
      print('  ${tensor.name}: shape=${tensor.shape}, type=${tensor.type}');
    }
    print('Outputs:');
    for (var tensor in interpreter.getOutputTensors()) {
      print('  ${tensor.name}: shape=${tensor.shape}, type=${tensor.type}');
    }
  });
}

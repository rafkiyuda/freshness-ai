import 'package:hive_flutter/hive_flutter.dart';
import '../config/constants.dart';

class IdGenerator {
  /// Generates QC Session ID: QC-{YYMMDD}-{SEQ}
  static Future<String> generateQcSessionId() async {
    final now = DateTime.now();
    final yy = now.year.toString().substring(2);
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final datePrefix = '$yy$mm$dd';

    final box = await Hive.openBox<int>(Constants.hiveBoxSettings);
    final key = 'seq_$datePrefix';
    
    int currentSeq = box.get(key) ?? 0;
    currentSeq++;
    await box.put(key, currentSeq);

    final seqStr = currentSeq.toString().padLeft(3, '0');
    return 'QC-$datePrefix-$seqStr';
  }
}

enum FreshnessStatus {
  fresh,    // Score 80-100, Color: Green
  warning,  // Score 60-79, Color: Yellow
  critical, // Score 0-59, Color: Red
}

enum StaffDecision {
  accept,          // Approved -> status becomes APPROVED_FOR_RECEIVING
  partialAccept,   // Partially approved -> status becomes APPROVED_FOR_RECEIVING
  reject,          // Rejected -> status becomes REJECTED
  needSorting,     // Needs sorting -> status becomes NEED_SORTING
}

class Constants {
  static const String hiveBoxQcSessions = 'qc_sessions_box';
  static const String hiveBoxSettings = 'settings_box';
  
  static const List<Map<String, String>> skuOptions = [
    {'skuId': 'KAN', 'skuName': 'Kangkung'},
    {'skuId': 'BAY', 'skuName': 'Bayam'},
    {'skuId': 'SAW', 'skuName': 'Sawi Putih'},
    {'skuId': 'WOR', 'skuName': 'Wortel'},
    {'skuId': 'BNC', 'skuName': 'Buncis'},
    {'skuId': 'DBW', 'skuName': 'Daun Bawang'},
    {'skuId': 'KOL', 'skuName': 'Kol'},
    {'skuId': 'TOM', 'skuName': 'Tomat'},
    {'skuId': 'APL', 'skuName': 'Apel'},
    {'skuId': 'PIS', 'skuName': 'Pisang'},
    {'skuId': 'PRK', 'skuName': 'Paprika'},
  ];

  static const List<Map<String, String>> supplierOptions = [
    {'id': 'SUP-001', 'name': 'Petani Pak Ahmad'},
    {'id': 'SUP-002', 'name': 'Petani Bu Siti'},
    {'id': 'SUP-003', 'name': 'Koperasi Tani Makmur'},
    {'id': 'SUP-004', 'name': 'Petani Pak Joko'},
  ];
}

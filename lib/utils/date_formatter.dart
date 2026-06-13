
class DateFormatter {
  static String formatIndonesian(DateTime date) {
    // Example: "13 Juni 2026, 10:00"
    // Since we don't have intl initialization setup for 'id_ID' yet, 
    // we can use manual mapping for months or standard format.
    final months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }
}

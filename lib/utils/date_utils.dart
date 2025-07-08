String formatDate(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}

String formatTime(DateTime dt) {
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dt) {
  return '${formatDate(dt)} ${formatTime(dt)}';
}

String formatDateTimeShort(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}';
}

DateTime startThisDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 0, 0, 0);
}

DateTime startThisMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month - 1, now.day, 0, 0, 0);
}

DateTime endThisDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 23, 59, 59);
}

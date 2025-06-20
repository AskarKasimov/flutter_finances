String formatDate(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}

String formatTime(DateTime dt) {
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dt) {
  return '${formatDate(dt)} ${formatTime(dt)}';
}

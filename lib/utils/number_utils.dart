import 'dart:ui';

String getDecimalSeparator(Locale locale) {
  // простейшая проверка: если язык русский, белорусский — запятая, иначе точка
  const commaLocales = ['ru', 'by'];
  if (commaLocales.contains(locale.languageCode)) {
    return ',';
  }
  return '.';
}

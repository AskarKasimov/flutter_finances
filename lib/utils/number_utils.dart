import 'dart:ui';

String getDecimalSeparator(Locale locale) {
  // простейшая проверка: если язык русский, белорусский — запятая, иначе точка
  const commaLocales = ['ru', 'by'];
  if (commaLocales.contains(locale.languageCode)) {
    return ',';
  }
  return '.';
}

String formatNumber(double value) {
  String formatDouble(double val) {
    // если целое число — без десятичных, иначе с одним знаком
    if (val % 1 == 0) {
      return val.toInt().toString();
    } else {
      return val.toStringAsFixed(1);
    }
  }

  if (value >= 1000000) {
    return '${formatDouble(value / 1000000)}M';
  } else if (value >= 1000) {
    return '${formatDouble(value / 1000)}K';
  } else {
    return value.toInt().toString();
  }
}

String formatNumber({required double value}) {
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

String formatCurrency({required double value, required String? currency}) {
  final intPart = value.truncate();
  final fracPart = value.remainder(1);

  final intStr = intPart.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ' ',
  );

  String result = intStr;
  if (fracPart != 0) {
    final fracStr = value.toStringAsFixed(2).split('.')[1];
    result += ',$fracStr';
  }

  if (currency != null && currency.isNotEmpty) {
    result += ' $currency';
  }

  return result;
}

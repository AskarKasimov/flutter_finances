class StatItem {
  final int _categoryId;
  final String _categoryName;
  final String _emoji;
  final double _amount;

  StatItem({
    required int categoryId,
    required String categoryName,
    required String emoji,
    required double amount,
  }) : _categoryId = categoryId,
       _categoryName = categoryName,
       _emoji = emoji,
       _amount = amount;
}

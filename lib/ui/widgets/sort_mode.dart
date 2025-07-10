import 'package:flutter_finances/domain/entities/transaction.dart';

abstract class SortMode {
  String get label;

  List<Transaction> sort(List<Transaction> transactions);

  static final values = <SortMode>[
    SortByDateDesc(),
    SortByDateAsc(),
    SortByAmountDesc(),
    SortByAmountAsc(),
  ];
}

class SortByDateDesc extends SortMode {
  @override
  String get label => 'Сначала новые';

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }
}

class SortByDateAsc extends SortMode {
  @override
  String get label => 'Сначала старые';

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }
}

class SortByAmountDesc extends SortMode {
  @override
  String get label => 'Сначала большие суммы';

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }
}

class SortByAmountAsc extends SortMode {
  @override
  String get label => 'Сначала меньшие суммы';

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => a.amount.compareTo(b.amount));
    return sorted;
  }
}

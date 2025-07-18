import 'package:flutter/cupertino.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';

abstract class SortMode {
  String getLabel(BuildContext context);

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
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  @override
  String getLabel(BuildContext context) =>
      AppLocalizations.of(context)!.sortByDateDesc;
}

class SortByDateAsc extends SortMode {
  @override
  String getLabel(BuildContext context) =>
      AppLocalizations.of(context)!.sortByDateAsc;

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }
}

class SortByAmountDesc extends SortMode {
  @override
  String getLabel(BuildContext context) =>
      AppLocalizations.of(context)!.sortByAmountDesc;

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }
}

class SortByAmountAsc extends SortMode {
  @override
  String getLabel(BuildContext context) =>
      AppLocalizations.of(context)!.sortByAmountAsc;

  @override
  List<Transaction> sort(List<Transaction> transactions) {
    final sorted = [...transactions];
    sorted.sort((a, b) => a.amount.compareTo(b.amount));
    return sorted;
  }
}

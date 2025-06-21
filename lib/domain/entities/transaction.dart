import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

class Transaction {
  final int _id;
  final int _accountId;
  final int? _categoryId;
  final Category? _category;
  final double _amount;
  final DateTime _timestamp;
  final String? _comment;
  final AuditInfoTime _timeInterval;

  Transaction({
    required int id,
    required int accountId,
    required int? categoryId,
    required Category? category,
    required double amount,
    required DateTime timestamp,
    required String? comment,
    required AuditInfoTime timeInterval,
  }) : _id = id,
       _accountId = accountId,
       _categoryId = categoryId,
       _category = category,
       _amount = amount,
       _timestamp = timestamp,
       _comment = comment,
       _timeInterval = timeInterval;

  AuditInfoTime get timeInterval => _timeInterval;

  String? get comment => _comment;

  DateTime get timestamp => _timestamp;

  double get amount => _amount;

  int? get categoryId => _categoryId;

  Category? get category => _category;

  int get accountId => _accountId;

  int get id => _id;
}

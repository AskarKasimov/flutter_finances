class AuditInfoTime {
  final DateTime _createdAt;
  final DateTime _updatedAt;

  AuditInfoTime({required DateTime createdAt, required DateTime updatedAt})
    : _createdAt = createdAt,
      _updatedAt = updatedAt;

  DateTime get updatedAt => _updatedAt;

  DateTime get createdAt => _createdAt;
}

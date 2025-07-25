import 'package:flutter_finances/data/local_data/dao/sync_event_dao.dart';
import 'package:flutter_finances/data/local_data/dao/transaction_dao.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/local_data/mappers.dart';
import 'package:flutter_finances/data/remote/mappers/transaction_mapper.dart';
import 'package:flutter_finances/data/remote/models/account_brief/account_brief.dart';
import 'package:flutter_finances/data/remote/models/category/category.dart';
import 'package:flutter_finances/data/remote/models/transaction/transaction.dart';
import 'package:flutter_finances/data/remote/models/transaction_request/transaction_request.dart';
import 'package:flutter_finances/data/remote/models/transaction_response/transaction_response.dart';
import 'package:flutter_finances/data/remote/services/transaction_api_service.dart';
import 'package:flutter_finances/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_finances/data/sync/sync_service.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApi extends Mock implements TransactionApiService {}

class MockDao extends Mock implements TransactionDao {}

class MockSyncEventDao extends Mock implements SyncEventDao {}

class MockSyncService extends Mock implements SyncService {}

void main() {
  late MockApi api;
  late MockDao dao;
  late MockSyncEventDao syncEventDao;
  late MockSyncService syncService;
  late TransactionRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      TransactionsCompanion.insert(
        accountId: 1,
        categoryId: 1,
        amount: 0.0,
        timestamp: DateTime.now(),
      ),
    );

    registerFallbackValue(
      TransactionRequestDTO(
        accountId: 0,
        categoryId: 0,
        amount: "0",
        transactionDate: DateTime.now().toIso8601String(),
        comment: null,
      ),
    );

    registerFallbackValue(
      SyncEventsCompanion.insert(
        entityId: 0,
        entityType: 'transaction',
        type: 'create',
        payload: '',
      ),
    );
  });

  setUp(() {
    api = MockApi();
    dao = MockDao();
    syncEventDao = MockSyncEventDao();
    syncService = MockSyncService();
    repository = TransactionRepositoryImpl(api, dao, syncEventDao, syncService);
  });

  group('createTransaction', () {
    test('createTransaction calls API with correct comment', () async {
      final form = TransactionForm(
        accountId: 1,
        categoryId: 2,
        amount: 100,
        timestamp: DateTime(2025, 1, 1),
        comment: 'Test',
      );

      final dto = TransactionDTO(
        id: 10,
        accountId: 1,
        categoryId: 2,
        amount: "100",
        transactionDate: DateTime(2025, 1, 1).toIso8601String(),
        comment: 'Test',
      );

      when(() => syncService.syncPendingEvents()).thenAnswer((_) async {});
      when(() => api.createTransaction(any())).thenAnswer((_) async => dto);
      when(() => dao.insertOrUpdateTransaction(any())).thenAnswer((_) async {});
      when(() => syncEventDao.insertEvent(any())).thenAnswer((_) async => 1);

      final result = await repository.createTransaction(form);

      expect(result.id, 10);
      expect(result.amount, 100);

      final capturedArgs = verify(
        () => api.createTransaction(captureAny()),
      ).captured;
      final arg = capturedArgs.first as TransactionRequestDTO;
      expect(arg.comment, form.comment);

      verifyInOrder([
        () => syncService.syncPendingEvents(),
        () => dao.insertOrUpdateTransaction(any()),
        () => syncEventDao.insertEvent(any()),
      ]);
    });
    test('createTransaction throws if API call fails', () async {
      final form = TransactionForm(
        accountId: 1,
        categoryId: 2,
        amount: 100,
        timestamp: DateTime(2025, 1, 1),
        comment: 'FailTest',
      );

      when(() => syncService.syncPendingEvents()).thenAnswer((_) async {});
      when(
        () => api.createTransaction(any()),
      ).thenThrow(Exception('API failure'));

      when(() => dao.insertOrUpdateTransaction(any())).thenAnswer((_) async {});
      when(() => syncEventDao.insertEvent(any())).thenAnswer((_) async => 1);

      expect(() => repository.createTransaction(form), throwsException);

      verify(() => syncService.syncPendingEvents()).called(1);
      verifyNever(() => dao.insertOrUpdateTransaction(any()));
      verifyNever(() => syncEventDao.insertEvent(any()));
    });
    test('createTransaction inserts SyncEvent with correct payload', () async {
      final form = TransactionForm(
        accountId: 1,
        categoryId: 2,
        amount: 100,
        timestamp: DateTime(2025, 1, 1),
        comment: 'PayloadTest',
      );

      final dto = TransactionDTO(
        id: 20,
        accountId: 1,
        categoryId: 2,
        amount: "100",
        transactionDate: DateTime(2025, 1, 1).toIso8601String(),
        comment: 'PayloadTest',
      );

      when(() => syncService.syncPendingEvents()).thenAnswer((_) async {});
      when(() => api.createTransaction(any())).thenAnswer((_) async => dto);
      when(() => dao.insertOrUpdateTransaction(any())).thenAnswer((_) async {});
      when(
        () => syncEventDao.insertEvent(captureAny()),
      ).thenAnswer((_) async => 1);

      final result = await repository.createTransaction(form);

      expect(result.id, 20);

      final capturedSyncEvent =
          verify(() => syncEventDao.insertEvent(captureAny())).captured.first
              as SyncEventsCompanion;
      final payloadJson = capturedSyncEvent.payload.value;

      expect(payloadJson.contains('"accountId":1'), isTrue);
      expect(payloadJson.contains('"categoryId":2'), isTrue);
      expect(
        payloadJson.contains('"amount":"100.0"') ||
            payloadJson.contains('"amount":"100"'),
        isTrue,
      );
      expect(payloadJson.contains('"comment":"PayloadTest"'), isTrue);
    });
  });
  group('getTransactionById', () {
    const testId = 123;
    final dto = TransactionResponseDTO(
      id: testId,
      account: const AccountBriefDTO(
        id: 1,
        name: "accounttt",
        balance: "102",
        currency: "RUB",
      ),
      category: const CategoryDTO(
        id: 2,
        name: "categ",
        emoji: "\$",
        isIncome: true,
      ),
      createdAt: DateTime.now().toTimeZoneAwareIso(),
      updatedAt: DateTime.now().toTimeZoneAwareIso(),
      amount: "42.0",
      transactionDate: DateTime(2025, 7, 25).toIso8601String(),
      comment: 'test comment',
    );

    final domainTransaction = dto.toDomain();

    final companion = domainTransaction.toCompanion();

    test('on API failure returns transaction from local DB', () async {
      when(() => syncService.syncPendingEvents()).thenAnswer((_) async {});
      when(
        () => api.getTransactionById(testId),
      ).thenThrow(Exception('API error'));

      final transactionData = Transaction(
        id: domainTransaction.id,
        accountId: domainTransaction.accountId,
        categoryId: domainTransaction.categoryId,
        amount: domainTransaction.amount,
        timestamp: domainTransaction.timestamp,
        comment: domainTransaction.comment,
      );

      when(
        () => dao.getTransactionById(testId),
      ).thenAnswer((_) async => transactionData);

      final result = await repository.getTransactionById(testId);

      expect(result.id, transactionData.id);
      expect(result.comment, transactionData.comment);

      verify(() => syncService.syncPendingEvents()).called(1);
      verify(() => api.getTransactionById(testId)).called(1);
      verify(() => dao.getTransactionById(testId)).called(1);
      verifyNever(() => dao.insertOrUpdateTransaction(any()));
    });

    test('returns transaction from API and saves locally', () async {
      when(() => syncService.syncPendingEvents()).thenAnswer((_) async {});
      when(() => api.getTransactionById(testId)).thenAnswer((_) async => dto);
      when(
        () => dao.insertOrUpdateTransaction(companion),
      ).thenAnswer((_) async {});

      final result = await repository.getTransactionById(testId);

      expect(result.id, dto.id);
      expect(result.comment, dto.comment);

      verifyInOrder([
        () => syncService.syncPendingEvents(),
        () => api.getTransactionById(testId),
        () => dao.insertOrUpdateTransaction(any()),
      ]);
    });

    test('throws if transaction not found locally after API failure', () async {
      when(() => syncService.syncPendingEvents()).thenAnswer((_) async {});
      when(
        () => api.getTransactionById(testId),
      ).thenThrow(Exception('API error'));
      when(() => dao.getTransactionById(testId)).thenAnswer((_) async => null);

      await expectLater(
        () => repository.getTransactionById(testId),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('not found locally'),
          ),
        ),
      );

      verify(() => syncService.syncPendingEvents()).called(1);
      verify(() => api.getTransactionById(testId)).called(1);
      verify(() => dao.getTransactionById(testId)).called(1);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_account_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_form.dart';

class TransactionCreationSheet extends StatelessWidget {
  final bool isIncome;
  final BuildContext parentContext;

  const TransactionCreationSheet({
    super.key,
    required this.parentContext,
    required this.isIncome,
  });

  void _onSubmit(BuildContext context) {
    final bloc = context.read<TransactionCreationBloc>();
    final state = bloc.state as TransactionDataState;

    if (state.isValid) {
      bloc.add(CreateTransactionSubmitted());
    } else {
      final error = state.validationError ?? 'Неизвестная ошибка';
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ОК'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionCreationBloc(
        context.read<MockedTransactionRepository>(),
        context.read<MockedCategoryRepository>(),
        context.read<MockedAccountRepository>(),
      ),
      child: BlocConsumer<TransactionCreationBloc, TransactionCreationState>(
        listener: (context, state) {
          switch (state) {
            case TransactionCreatedSuccessfully(:final createdTransaction):
              BlocProvider.of<TransactionHistoryBloc>(
                parentContext,
              ).add(AddSingleTransaction(createdTransaction));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text('Транзакция успешно добавлена')),
              );
              break;

            case TransactionProcessing():
              ScaffoldMessenger.of(
                parentContext,
              ).showSnackBar(const SnackBar(content: Text('Загрузка...')));
              break;

            case TransactionUpdatedSuccessfully():
              // такого не будет
              break;

            case TransactionDeletedSuccessfully():
              // такого не будет
              break;

            case TransactionDataState():
              // такого не будет
              break;
          }
        },
        builder: (context, state) {
          return switch (state) {
            TransactionProcessing() => const Center(
              child: CircularProgressIndicator(),
            ),
            _ => Scaffold(
              appBar: AppBar(
                title: Text(isIncome ? 'Добавить доход' : 'Добавить расход'),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  Builder(
                    builder: (localContext) => IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => _onSubmit(localContext),
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
              ),
              body: TransactionForm(isIncome: isIncome),
            ),
          };
        },
      ),
    );
  }
}

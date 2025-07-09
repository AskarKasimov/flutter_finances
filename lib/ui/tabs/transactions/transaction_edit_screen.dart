import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_account_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_form.dart';
import 'package:go_router/go_router.dart';

class TransactionEditScreen extends StatelessWidget {
  final int transactionId;

  const TransactionEditScreen({super.key, required this.transactionId});

  void _onSubmit(BuildContext context) {
    final bloc = context.read<TransactionCreationBloc>();
    final state = bloc.state as TransactionDataState;

    if (state.isValid) {
      bloc.add(UpdateTransactionSubmitted(transactionId: transactionId));
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

  void _onDelete(BuildContext context) {
    context.read<TransactionCreationBloc>().add(
      DeleteTransactionSubmitted(transactionId: transactionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionCreationBloc(
        context.read<MockedTransactionRepository>(),
        context.read<MockedCategoryRepository>(),
        context.read<MockedAccountRepository>(),
      )..add(InitializeForEditing(transactionId: transactionId)),
      child: BlocListener<TransactionCreationBloc, TransactionCreationState>(
        listener: (context, state) {
          final historyBloc = context.read<TransactionHistoryBloc>();
          switch (state) {
            case TransactionUpdatedSuccessfully():
              historyBloc.add(UpdateTransaction(state.updatedTransaction));
              context.pop();
              break;
            case TransactionDeletedSuccessfully():
              historyBloc.add(DeleteTransaction(state.deletedTransaction));
              context.pop();
              break;
            case TransactionDataState():
              break;
            case TransactionProcessing():
              break;
            case TransactionCreatedSuccessfully():
              break;
          }
        },
        child: BlocBuilder<TransactionCreationBloc, TransactionCreationState>(
          builder: (context, creationState) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                if (creationState is! TransactionDataState) {
                  return const Center(child: CircularProgressIndicator());
                }

                bool isIncome = false;
                if (categoryState is CategoryLoaded &&
                    creationState.category != null) {
                  final category = categoryState.categories.firstWhere(
                    (c) => c.id == creationState.category!.id,
                  );
                  isIncome = category.isIncome;
                }

                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Редактировать транзакцию'),
                    centerTitle: true,
                    actions: [
                      Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => _onSubmit(ctx),
                        ),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(child: TransactionForm(isIncome: isIncome)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () => _onDelete(context),
                          label: const Text('Удалить'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

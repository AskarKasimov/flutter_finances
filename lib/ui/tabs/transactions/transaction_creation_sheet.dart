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
import 'package:flutter_finances/ui/tabs/transactions/transaction_form.dart'; // <- импорт твоей формы

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
    final state = bloc.state;

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
      child: BlocListener<TransactionCreationBloc, TransactionCreationState>(
        listener: (context, state) {
          if (state is TransactionSubmittedSuccessfully) {
            BlocProvider.of<TransactionHistoryBloc>(
              parentContext,
            ).add(AddSingleTransaction(state.createdTransaction));
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Мои расходы'),
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
          // Используем готовый виджет формы, передавая isIncome:
          body: TransactionForm(isIncome: isIncome),
        ),
      ),
    );
  }
}

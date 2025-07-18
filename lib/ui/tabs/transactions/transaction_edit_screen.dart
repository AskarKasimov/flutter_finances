import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_accounts_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_form.dart';
import 'package:go_router/go_router.dart';

class TransactionEditScreen extends StatelessWidget {
  final int transactionId;

  const TransactionEditScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionCreationBloc>(
      create: (_) {
        final bloc = TransactionCreationBloc(
          deleteTransactionUseCase: context.read<DeleteTransactionUseCase>(),
          getAllAccountsUseCase: context.read<GetAllAccountsUseCase>(),
          getTransactionByIdUseCase: context.read<GetTransactionByIdUseCase>(),
          getAllCategoriesUseCase: context.read<GetAllCategoriesUseCase>(),
          updateTransactionUseCase: context.read<UpdateTransactionUseCase>(),
          createTransactionUseCase: context.read<CreateTransactionUseCase>(),
        );
        bloc.add(InitializeForEditing(transactionId: transactionId));
        return bloc;
      },
      child: _TransactionEditScreen(transactionId: transactionId),
    );
  }
}

class _TransactionEditScreen extends StatelessWidget {
  final int transactionId;

  const _TransactionEditScreen({required this.transactionId});

  void _onSubmit(BuildContext context) {
    final bloc = context.read<TransactionCreationBloc>();
    final state = bloc.state as TransactionDataState;
    final loc = AppLocalizations.of(context)!;

    if (state.isValid) {
      bloc.add(UpdateTransactionSubmitted(transactionId: transactionId));
    } else {
      final error = state.validationError ?? loc.errorUnknown;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(loc.errorTitle),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.ok),
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
    final loc = AppLocalizations.of(context)!;

    return BlocListener<TransactionCreationBloc, TransactionCreationState>(
      listener: (context, state) {
        switch (state) {
          case TransactionUpdatedSuccessfully():
            context.pop();
            break;
          case TransactionDeletedSuccessfully():
            context.pop();
            break;
          case TransactionError(:final message):
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(loc.errorTitle),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(loc.ok),
                  ),
                ],
              ),
            );
            break;
          case TransactionDataState():
          case TransactionProcessing():
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
                  title: Text(loc.transactionEditTitle),
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
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () => _onDelete(context),
                        label: Text(loc.delete),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

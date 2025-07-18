import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_accounts_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_form.dart';

class _TransactionCreationSheet extends StatelessWidget {
  final bool isIncome;

  const _TransactionCreationSheet({required this.isIncome});

  void _onSubmit(BuildContext context) {
    final bloc = context.read<TransactionCreationBloc>();
    final state = bloc.state as TransactionDataState;
    final loc = AppLocalizations.of(context)!;

    if (state.isValid) {
      bloc.add(CreateTransactionSubmitted());
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocConsumer<TransactionCreationBloc, TransactionCreationState>(
      listener: (context, state) {
        switch (state) {
          case TransactionCreatedSuccessfully():
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(loc.transactionCreated)));
            Navigator.of(context).pop();
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

          default:
            break;
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(isIncome ? loc.addIncome : loc.addExpense),
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
        body: switch (state) {
          TransactionProcessing() => const Center(
            child: CircularProgressIndicator(),
          ),
          _ => TransactionForm(isIncome: isIncome),
        },
      ),
    );
  }
}

void showTransactionCreationSheet({
  required BuildContext context,
  required bool isIncome,
}) {
  final mediaQuery = MediaQuery.of(context);
  final statusBarHeight = mediaQuery.padding.top;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => TransactionCreationBloc(
        deleteTransactionUseCase: context.read<DeleteTransactionUseCase>(),
        getAllAccountsUseCase: context.read<GetAllAccountsUseCase>(),
        getTransactionByIdUseCase: context.read<GetTransactionByIdUseCase>(),
        getAllCategoriesUseCase: context.read<GetAllCategoriesUseCase>(),
        updateTransactionUseCase: context.read<UpdateTransactionUseCase>(),
        createTransactionUseCase: context.read<CreateTransactionUseCase>(),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: _TransactionCreationSheet(isIncome: isIncome),
      ),
    ),
  );
}

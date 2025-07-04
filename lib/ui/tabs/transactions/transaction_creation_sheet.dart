import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';
import 'package:flutter_finances/utils/date_utils.dart';

class TransactionCreationSheet extends StatelessWidget {
  const TransactionCreationSheet({super.key});

  void _onSubmit(BuildContext context) {
    final bloc = context.read<TransactionCreationBloc>();
    final state = bloc.state;

    if (state.isValid) {
      bloc.add(TransactionSubmitted());
      Navigator.of(context).pop();
    } else {
      final error = state.validationError ?? 'Неизвестная ошибка';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionCreationBloc(),
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
        body: _TransactionForm(),
      ),
    );
  }
}

class _TransactionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCreationBloc, TransactionCreationState>(
      builder: (context, state) {
        return Column(
          children: [
            // --- СЧЁТ ---
            ListTile(
              title: Text(
                'Счёт',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.account != null ? state.account!.name : 'Не выбран',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
              onTap: () {
                // TODO: выбор счёта
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- КАТЕГОРИЯ ---
            ListTile(
              title: Text(
                'Статья',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.category != null
                        ? state.category!.name
                        : 'Не выбрано',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
              onTap: () {
                // TODO: выбор категории
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- СУММА ---
            ListTile(
              title: Text(
                'Сумма',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                state.amount > 0 ? state.amount.toString() : 'Не указано',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                final controller = TextEditingController(
                  text: state.amount == 0 ? '' : state.amount.toString(),
                );
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Введите сумму'),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Отмена'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final amount =
                              double.tryParse(controller.text) ?? 0.0;
                          context.read<TransactionCreationBloc>().add(
                            TransactionAmountChanged(amount),
                          );
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- ДАТА ---
            ListTile(
              title: Text(
                'Дата',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                formatDate(state.date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  final newDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    state.date.hour,
                    state.date.minute,
                  );
                  context.read<TransactionCreationBloc>().add(
                    TransactionDateChanged(newDate),
                  );
                }
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- ВРЕМЯ ---
            ListTile(
              title: Text(
                'Время',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                formatTime(state.date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(state.date),
                );
                if (time != null) {
                  final newDate = DateTime(
                    state.date.year,
                    state.date.month,
                    state.date.day,
                    time.hour,
                    time.minute,
                  );
                  context.read<TransactionCreationBloc>().add(
                    TransactionDateChanged(newDate),
                  );
                }
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- КОММЕНТАРИЙ ---
            ListTile(
              title: TextFormField(
                initialValue: state.comment,
                onChanged: (value) => context
                    .read<TransactionCreationBloc>()
                    .add(TransactionCommentChanged(value)),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Комментарий...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                ),
              ),
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';
import 'package:flutter_finances/ui/widgets/selection_bottom_sheet.dart';
import 'package:flutter_finances/utils/color_utils.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:flutter_finances/utils/number_utils.dart';

class TransactionForm extends StatefulWidget {
  final bool isIncome;

  const TransactionForm({super.key, required this.isIncome});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<TransactionCreationBloc, TransactionCreationState>(
      builder: (context, state) {
        if (state is! TransactionDataState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_commentController.text != state.comment) {
          _commentController.text = state.comment;
          _commentController.selection = TextSelection.fromPosition(
            TextPosition(offset: _commentController.text.length),
          );
        }

        return Column(
          children: [
            // --- ACCOUNT ---
            ListTile(
              title: Text(
                loc.account,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.accountState != null
                        ? state.accountState!.name
                        : loc.accountNotSelected,
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
                _showAccountSelection(context, loc);
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- CATEGORY ---
            ListTile(
              title: Text(
                loc.category,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.category != null
                        ? state.category!.name
                        : loc.categoryNotSelected,
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
                _showCategorySelection(context, widget.isIncome, loc);
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- AMOUNT ---
            ListTile(
              title: Text(
                loc.amount,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                state.amount > 0
                    ? state.amount.toString()
                    : loc.amountNotSpecified,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                final controller = TextEditingController(
                  text: state.amount == 0
                      ? ''
                      : formatCurrency(value: state.amount, currency: null),
                );
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(loc.enterAmount),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('^\\d*,?\\d{0,2}'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(loc.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final amount =
                              double.tryParse(
                                controller.text.replaceAll(',', '.'),
                              ) ??
                              0.0;
                          context.read<TransactionCreationBloc>().add(
                            TransactionAmountChanged(amount),
                          );
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(loc.ok),
                      ),
                    ],
                  ),
                );
              },
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            // --- DATE ---
            ListTile(
              title: Text(
                loc.date,
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

            // --- TIME ---
            ListTile(
              title: Text(
                loc.time,
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

            // --- COMMENT ---
            ListTile(
              title: TextFormField(
                controller: _commentController,
                onChanged: (value) => context
                    .read<TransactionCreationBloc>()
                    .add(TransactionCommentChanged(value)),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: loc.commentHint,
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

  void _showAccountSelection(BuildContext context, AppLocalizations loc) {
    showSelectionBottomSheet<AccountState>(
      context: context,
      title: loc.selectAccountTitle,
      stateSelector: (ctx) {
        final state = ctx.watch<AccountBloc>().state;
        return switch (state) {
          AccountBlocLoading() => (items: [], isLoading: true, error: null),
          AccountBlocLoaded(:final account) => (
            items: [account],
            isLoading: false,
            error: null,
          ),
          AccountBlocError(:final message) => (
            items: [],
            isLoading: false,
            error: message,
          ),
        };
      },
      itemBuilder: (ctx, account) => ListTile(
        title: Text(account.name),
        subtitle: Text(
          '${loc.balance}: ${account.moneyDetails.balance} ${account.moneyDetails.currency}',
        ),
      ),
      onItemSelected: (account) {
        context.read<TransactionCreationBloc>().add(
          TransactionAccountChanged(account),
        );
      },
    );
  }

  void _showCategorySelection(
    BuildContext context,
    bool isIncome,
    AppLocalizations loc,
  ) {
    showSelectionBottomSheet<Category>(
      context: context,
      title: loc.category,
      stateSelector: (ctx) {
        final state = ctx.watch<CategoryBloc>().state;
        return switch (state) {
          CategoryLoading() => (items: [], isLoading: true, error: null),
          CategoryError() => (
            items: [],
            isLoading: false,
            error: loc.errorLoadingCategories,
          ),
          CategoryLoaded(:final categories) => (
            items: categories.where((c) => c.isIncome == isIncome).toList(),
            isLoading: false,
            error: null,
          ),
          _ => (items: [], isLoading: true, error: null),
        };
      },
      itemBuilder: (ctx, category) => ListTile(
        title: Text(category.name),
        leading: CircleAvatar(
          backgroundColor: generateLightColorFromId(category.id),
          child: Text(category.emoji),
        ),
      ),
      onItemSelected: (category) {
        context.read<TransactionCreationBloc>().add(
          TransactionCategoryChanged(category),
        );
      },
    );
  }
}

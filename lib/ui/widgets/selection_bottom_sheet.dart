import 'package:flutter/material.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef OnItemSelected<T> = void Function(T item);
typedef SelectionState<T> = ({List<T> items, bool isLoading, String? error});

void showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required SelectionState<T> Function(BuildContext) stateSelector,
  required ItemBuilder<T> itemBuilder,
  required OnItemSelected<T> onItemSelected,
}) {
  showModalBottomSheet(
    context: context,
    builder: (modalContext) {
      final screenHeight = MediaQuery.of(modalContext).size.height;
      final theme = Theme.of(modalContext);

      final state = stateSelector(modalContext);

      return SizedBox(
        height: screenHeight * 0.4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            Divider(height: 1, color: theme.dividerColor),
            Expanded(
              child: Builder(
                builder: (ctx) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error case final msg?) {
                    return Center(child: Text('${AppLocalizations.of(ctx)!.errorTitle}: $msg'));
                  } else if (state.items.isEmpty) {
                    return Center(child: Text(AppLocalizations.of(ctx)!.noDataFound));
                  }

                  return ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (ctx, index) {
                      final item = state.items[index];
                      return InkWell(
                        onTap: () {
                          onItemSelected(item);
                          Navigator.of(modalContext).pop();
                        },
                        child: itemBuilder(ctx, item),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

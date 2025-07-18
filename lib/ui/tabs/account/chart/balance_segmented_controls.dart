import 'package:flutter/material.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';

enum StatsPeriod { day, month }

class BalanceSegmentedControls extends StatelessWidget {
  final StatsPeriod selectedPeriod;
  final void Function(StatsPeriod) onChanged;

  const BalanceSegmentedControls({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SegmentedButton<StatsPeriod>(
      segments: [
        ButtonSegment(value: StatsPeriod.day, label: Text(loc.statsPeriodDay)),
        ButtonSegment(
          value: StatsPeriod.month,
          label: Text(loc.statsPeriodMonth),
        ),
      ],
      selected: {selectedPeriod},
      onSelectionChanged: (newSelection) {
        if (newSelection.isNotEmpty) {
          onChanged(newSelection.first);
        }
      },
    );
  }
}

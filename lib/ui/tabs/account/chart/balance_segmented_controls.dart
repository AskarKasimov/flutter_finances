import 'package:flutter/material.dart';

enum StatsPeriod { day, month }

class BalanceSegmentedContorls extends StatelessWidget {
  final StatsPeriod selectedPeriod;
  final void Function(StatsPeriod) onChanged;

  const BalanceSegmentedContorls({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<StatsPeriod>(
      segments: const [
        ButtonSegment(
          value: StatsPeriod.day,
          label: Text('По дням'),
        ),
        ButtonSegment(
          value: StatsPeriod.month,
          label: Text('По месяцам'),
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

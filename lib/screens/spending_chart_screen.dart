import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/services/transaction_service.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingChartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Spending Chart')),
      body: transactionsAsync.when(
        data: (transactions) {
          final spendingMap = ref
              .read(transactionServiceProvider.notifier)
              .getCategorySpendingMap();
          return Center(
            child: PieChart(
              PieChartData(
                sections: spendingMap.entries.map((entry) {
                  return PieChartSectionData(
                    color: Colors.primaries[
                        spendingMap.keys.toList().indexOf(entry.key) %
                            Colors.primaries.length],
                    value: entry.value,
                    title: '${entry.key}\n${entry.value.toStringAsFixed(2)}',
                    radius: 100,
                  );
                }).toList(),
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

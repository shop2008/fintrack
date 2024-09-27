import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/services/transaction_service.dart';
import 'package:fintrack/models/transaction.dart';

class BudgetScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetServiceProvider);
    final transactionService = ref.watch(transactionServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Budget Management')),
      body: budgetsAsync.when(
        data: (budgets) => ListView.builder(
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];
            final spending = transactionService.value
                    ?.where((t) =>
                        t.category == budget.category &&
                        t.type == TransactionType.expense)
                    .fold(0.0, (sum, t) => sum + t.amount) ??
                0.0;
            final progress = spending / budget.limit;

            return ListTile(
              title: Text(budget.category),
              subtitle: LinearProgressIndicator(value: progress),
              trailing: Text(
                  '\$${spending.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}'),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context, ref),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    // Implement dialog to add new budget
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:fintrack/models/budget.dart';
import 'package:fintrack/services/database_helper.dart';

part 'transaction_service.g.dart';

@riverpod
class TransactionService extends _$TransactionService {
  @override
  Future<List<Transaction>> build() async {
    return await DatabaseHelper.instance.getTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await DatabaseHelper.instance.insertTransaction(transaction);
    state =
        await AsyncValue.guard(() => DatabaseHelper.instance.getTransactions());
  }

  Future<void> deleteTransaction(String id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    state =
        await AsyncValue.guard(() => DatabaseHelper.instance.getTransactions());
  }

  double getTotalBalance() {
    return state.value?.fold(0.0, (sum, item) => (sum ?? 0.0) + item.amount) ??
        0.0;
  }

  Map<String, double> getCategorySpendingMap() {
    final spendingMap = <String, double>{};
    state.value?.forEach((transaction) {
      if (transaction.type == TransactionType.expense) {
        final category = transaction.category.name;
        spendingMap[category] =
            (spendingMap[category] ?? 0) + transaction.amount;
      }
    });
    return spendingMap;
  }
}

@riverpod
class BudgetService extends _$BudgetService {
  @override
  Future<List<Budget>> build() async {
    return await DatabaseHelper.instance.getBudgets();
  }

  Future<void> addBudget(Budget budget) async {
    await DatabaseHelper.instance.insertBudget(budget);
    state = await AsyncValue.guard(() => DatabaseHelper.instance.getBudgets());
  }

  Future<void> updateBudget(Budget budget) async {
    await DatabaseHelper.instance.updateBudget(budget);
    state = await AsyncValue.guard(() => DatabaseHelper.instance.getBudgets());
  }
}

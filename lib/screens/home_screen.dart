import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/services/auth_service.dart';
import 'package:fintrack/services/transaction_service.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:fintrack/screens/transaction_detail_screen.dart';
import 'package:fintrack/screens/budget_screen.dart';
import 'package:fintrack/screens/spending_chart_screen.dart';
import 'package:fintrack/screens/add_transaction_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transactionsAsync = ref.watch(transactionServiceProvider);
    final authService = ref.watch(authServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('FinTrack', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          _buildAppBarAction(
            icon: Icons.pie_chart,
            onPressed: () => _navigateTo(context, SpendingChartScreen()),
          ),
          _buildAppBarAction(
            icon: Icons.account_balance_wallet,
            onPressed: () => _navigateTo(context, BudgetScreen()),
          ),
          _buildAppBarAction(
            icon: Icons.exit_to_app,
            onPressed: authService.logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // _buildHeader(),
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) => _buildTransactionList(transactions),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(context, AddTransactionScreen()),
        child: Icon(Icons.add),
        backgroundColor: theme.primaryColor,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Track your finances with ease',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionListTile(context, transaction);
      },
    );
  }

  Widget _buildTransactionListTile(
      BuildContext context, Transaction transaction) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: transaction.type == TransactionType.income
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.error.withOpacity(0.1),
          child: Icon(
            transaction.type == TransactionType.income
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: transaction.type == TransactionType.income
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
        ),
        title: Text(
          transaction.category.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy').format(transaction.date),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: transaction.type == TransactionType.income
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
        ),
        onTap: () => _navigateTo(
          context,
          TransactionDetailScreen(transaction: transaction),
        ),
      ),
    );
  }
}

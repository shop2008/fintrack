import 'package:flutter/material.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  TransactionDetailScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${transaction.title}',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            Text('Amount: \$${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 8),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(transaction.date)}',
                style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 8),
            Text('Category: ${transaction.category.toString().split('.').last}',
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ),
    );
  }
}

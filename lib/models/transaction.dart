enum TransactionCategory {
  food,
  transportation,
  entertainment,
  utilities,
  other
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionCategory category;
  final String account;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.account,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
      'account': account,
      'type': type.name,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: TransactionCategory.values
          .firstWhere((e) => e.name == map['category']),
      account: map['account'],
      type: TransactionType.values.firstWhere((e) => e.name == map['type']),
    );
  }
}

enum TransactionType {
  expense('Expense'),
  income('Income'),
  transfer('Transfer');

  final String displayName;
  const TransactionType(this.displayName);
}

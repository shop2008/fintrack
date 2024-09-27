class Budget {
  final String category;
  final double limit;

  Budget({required this.category, required this.limit});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'limit': limit,
    };
  }

  static Budget fromMap(Map<String, dynamic> map) {
    return Budget(
      category: map['category'],
      limit: map['limit'],
    );
  }
}

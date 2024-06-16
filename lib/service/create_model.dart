class Transaction {
  final String name;
  final int amount;
  final String currency;

  Transaction({required this.name, required this.amount, required this.currency});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'currency': currency,
    };
  }
}
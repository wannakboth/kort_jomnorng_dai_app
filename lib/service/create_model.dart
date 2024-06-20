class Transaction {
  final String name;
  final double amount;
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

class CreateResponse {
  final int errorCode;
  final String status;

  CreateResponse(
      {required this.errorCode, required this.status});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    return CreateResponse(
      errorCode: json['errorCode'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'status': status,
    };
  }
}

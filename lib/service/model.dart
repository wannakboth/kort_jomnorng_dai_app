class Item {
  final String id;
  final String name;
  final String? amount;
  final String? currency;

  Item({required this.id, required this.name, this.amount, this.currency});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'currency': currency,
    };
  }
}

class Data {
  final List<Item>? items;
  final String? totalDollar;
  final String? totalRiel;

  Data({ this.items,  this.totalDollar,  this.totalRiel});

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Item> itemsList = list.map((i) => Item.fromJson(i)).toList();

    return Data(
      items: itemsList,
      totalDollar: json['totalDollar'],
      totalRiel: json['totalRiel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((item) => item.toJson()).toList(),
      'totalDollar': totalDollar,
      'totalRiel': totalRiel,
    };
  }
}

class ApiResponse {
  final Data? data;
  final int? errorCode;
  final String? status;

  ApiResponse({ this.data,  this.errorCode,  this.status});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: Data.fromJson(json['data']),
      errorCode: json['errorCode'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'errorCode': errorCode,
      'status': status,
    };
  }
}

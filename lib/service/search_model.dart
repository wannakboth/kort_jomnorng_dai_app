class Item {
  final String id;
  final int count;
  final String name;
  final String amount;
  final String currency;

  Item(
      {required this.id,
      required this.count,
      required this.name,
      required this.amount,
      required this.currency});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      count: json['count'],
      name: json['name'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
      'name': name,
      'amount': amount,
      'currency': currency,
    };
  }
}

class Data {
  final List<Item> items;
  final String totalDollar;
  final String totalRiel;

  Data(
      {required this.items,
      required this.totalDollar,
      required this.totalRiel});

  factory Data.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List;
    List<Item> items = itemList.map((i) => Item.fromJson(i)).toList();

    return Data(
      items: items,
      totalDollar: json['totalDollar'],
      totalRiel: json['totalRiel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalDollar': totalDollar,
      'totalRiel': totalRiel,
    };
  }
}

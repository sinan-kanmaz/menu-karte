class Amount {
  double? amount;
  double? unitPrice;
  String? unit;

  Amount({required this.amount, required this.unitPrice, required this.unit});

  Amount.fromJson(dynamic json) {
    amount = json['amount'];
    unitPrice = json['unitPrice'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['unitPrice'] = unitPrice;
    map['unit'] = unit;

    return map;
  }

  @override
  String toString() {
    return "Amount(amount: $amount, unitPrice: $unitPrice, unit: $unit)";
  }
}

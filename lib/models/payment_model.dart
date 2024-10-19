import 'dart:convert';

class PaymentModel {
  final String id;
  final String name;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final bool isPreferred;

  const PaymentModel({
    required this.id,
    required this.name,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    this.isPreferred = false,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'cardNumber': cardNumber});
    result.addAll({'expiryDate': expiryDate});
    result.addAll({'cvv': cvv});
    result.addAll({'isPreferred': isPreferred});

    return result;
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      isPreferred: map['isPreferred'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source));

  PaymentModel copyWith({
    String? id,
    String? name,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    bool? isPreferred,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isPreferred: isPreferred ?? this.isPreferred,
    );
  }
}
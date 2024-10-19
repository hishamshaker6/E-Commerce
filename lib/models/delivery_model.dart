
class DeliveryModel {
  final String id;
  final String name;
  final String days;
  final String imgUrl;
  final int  price;

  DeliveryModel({
    required this.id,
    required this.name,
    required this.days,
    required this.imgUrl,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'days': days});
    result.addAll({'imgUrl': imgUrl});
    result.addAll({'price': price});

    return result;
  }

  factory DeliveryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DeliveryModel(
      id: documentId,
      name: map['name'] ?? '',
      days: map['days'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }
}
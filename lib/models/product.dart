class ProductModel {
  final String id;
  final String title;
  final int price;
  final String imgUrl;
  final int discountValue;
  final String brandName;
  final String description;
  final String categoryType;


  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imgUrl,
    this.discountValue = 0,
    this.brandName = 'Other',
    this.description = '',
    this.categoryType = 'general',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imgUrl': imgUrl,
      'discountValue': discountValue,
      'brandName': brandName,
      'description': description,
      'categoryType': categoryType,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      title: map['title'] as String? ?? 'No Title',
      price: map['price'] as int? ?? 0,
      imgUrl: map['imgUrl'] as String? ?? 'No Data',
      discountValue: map['discountValue'] as int? ?? 0,
      brandName: map['brandName'] as String? ?? 'Other',
      description: map['description'] as String? ?? '',
      categoryType: map['categoryType'] as String? ?? 'general',
    );
  }
}

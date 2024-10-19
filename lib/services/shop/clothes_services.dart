
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class ClothesServices {
  Future<List<ProductModel>> getClothes();
}

class ClothesServicesImpl implements ClothesServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductModel>> getClothes() async {
    return await _getClothes();
  }


  Future<List<ProductModel>> _getClothes({Query Function(Query query)? queryBuilder}) async {
    return await firestoreServices.getCollection(
      path: ApiPath.clothes(),
      builder: (data, documentId) {
        return ProductModel.fromMap(data, documentId);
      },
      queryBuilder: queryBuilder,

    );
  }
}
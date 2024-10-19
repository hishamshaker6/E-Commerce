
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class NewClothesServices {
  Future<List<ProductModel>> getNewClothes();
}

class NewClothesServicesImpl implements NewClothesServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductModel>> getNewClothes() async {
    return await _getNewClothes();
  }


  Future<List<ProductModel>> _getNewClothes({Query Function(Query query)? queryBuilder}) async {
    return await firestoreServices.getCollection(
      path: ApiPath.newClothes(),
      builder: (data, documentId) {
        return ProductModel.fromMap(data, documentId);
      },
      queryBuilder: queryBuilder,

    );
  }
}
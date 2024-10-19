import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class ShoesServices{
  Future<List<ProductModel>> getShoes();
}

class ShoesServicesImpl implements  ShoesServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductModel>> getShoes() async {
    return await _getShoes();
  }


  Future<List<ProductModel>> _getShoes({Query Function(Query query)? queryBuilder}) async {
    return await firestoreServices.getCollection(
      path: ApiPath.shoes(),
      builder: (data, documentId) {
        return ProductModel.fromMap(data, documentId);
      },
      queryBuilder: queryBuilder,

    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class AccessoriesServices {
  Future<List<ProductModel>> getAccessories();
}

class AccessoriesServicesImpl implements AccessoriesServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductModel>> getAccessories() async {
    return await _getAccessories();
  }

  Future<List<ProductModel>> _getAccessories({Query Function(Query query)? queryBuilder}) async {
    return await firestoreServices.getCollection(
      path: ApiPath.accessories(),
      builder: (data, documentId) {
        return ProductModel.fromMap(data, documentId);
      },
      queryBuilder: queryBuilder,
    );
  }
}

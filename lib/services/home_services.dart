import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class HomeServices {
  Future<List<ProductModel>> getSalesProducts();
  Future<List<ProductModel>> getNewProducts();
}

class HomeServicesImpl implements HomeServices {
  final FirestoreServices firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductModel>> getNewProducts() async {
    try {
      return await _getProducts(
        queryBuilder: (query) => query.where('discountValue', isEqualTo: 0),
      );
    } catch (e) {
      throw Exception('Failure to bring new products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getSalesProducts() async {
    try {
      return await _getProducts(
        queryBuilder: (query) => query.where('discountValue', isNotEqualTo: 0),
      );
    } catch (e) {
      throw Exception('Failure to bring sales products: $e');
    }
  }

  Future<List<ProductModel>> _getProducts({Query Function(Query query)? queryBuilder}) async {
    return await firestoreServices.getCollection(
      path: ApiPath.products(),
      builder: (data, documentId) => ProductModel.fromMap(data, documentId),
      queryBuilder: queryBuilder,
    );
  }
}

import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class FavoriteServices {
  Future<void> addProductToFavorites(String userId, ProductModel favoriteProduct);
  Future<void> removeProductFromFavorites(String userId, String productId);
  Future<List<ProductModel>> getFavoriteProducts(String userId);
}

class FavoriteServicesImpl implements FavoriteServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> addProductToFavorites(String userId,
      ProductModel favoriteProduct) async {
    try {
      await firestoreServices.setData(
        path: ApiPath.addToFavorites(userId, favoriteProduct.id),
        data: favoriteProduct.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to add product to favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> removeProductFromFavorites(String userId,
      String productId) async {
    try {
      await firestoreServices.deleteData(
        path: ApiPath.removeFromFavorites(userId, productId),
      );
    } catch (e) {
      throw Exception(
          'Failed to remove product from favorites: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts(String userId) async {
    try {
      return await firestoreServices.getCollection(
        path: ApiPath.myFavoriteProducts(userId),
        builder: (data, documentId) => ProductModel.fromMap(data, documentId),
      );
    } catch (e) {
      throw Exception('Failed to get favorite products: ${e.toString()}');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinestore/models/cart_model.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class CartServices {
  Future<void> addProductToCart(String userId, CartModel cartProduct);
  Future<List<CartModel>> getCartProducts(String userId);
}

class CartServicesImpl implements CartServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> addProductToCart(String userId, CartModel cartProduct) async {
    try {
      final cartProducts = await getCartProducts(userId);
      final exists = cartProducts.any((item) => item.id == cartProduct.id);

      if (exists) {
        throw Exception('Product already in cart');
      }
      await firestoreServices.setData(
        path: ApiPath.addToCart(userId, cartProduct.id),
        data: cartProduct.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to add product to cart: ${e.toString()}');
    }
  }

  @override
  Future<List<CartModel>> getCartProducts(String userId,{Query Function(Query query)? queryBuilder}) async {
    try {
      return await firestoreServices.getCollection(
        path: ApiPath.myProductsCart(userId),
        builder: (data, documentId) => CartModel.fromMap(data, documentId),
      );
    } catch (e) {
      throw Exception('Failed to get cart products: ${e.toString()}');
    }
  }
  Future<void> removeProductFromCart(String userId, String productId) async {
    try {
      await firestoreServices.deleteData(path: ApiPath.addToCart(userId, productId));
    } catch (e) {
      throw Exception('Failed to remove product from cart: ${e.toString()}');
    }
  }
  Future<void> updateProductInCart(String userId, CartModel cartProduct) async {
    try {
      await firestoreServices.setData(
        path: ApiPath.addToCart(userId, cartProduct.id),
        data: cartProduct.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update product in cart: ${e.toString()}');
    }
  }
}

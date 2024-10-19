import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class ProductDetailsServices {
  Future<ProductModel> getProductDetails(String productId, String categoryType);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<ProductModel> getProductDetails(String productId, String categoryType) async {
    try {
      String path;

      switch (categoryType) {
        case 'newClothes':
          path = ApiPath.newClothesPath(productId);
          break;
        case 'clothes':
          path = ApiPath.clothesPath(productId);
          break;
        case 'shoes':
          path = ApiPath.shoesPath(productId);
          break;
        case 'accessories':
          path = ApiPath.accessoriesPath(productId);
          break;
        case 'product':
          path = ApiPath.product(productId);
          break;
        default:
          throw Exception('Invalid category type');
      }

      final data = await firestoreServices.getDocument(
        path: path,
      );

      if (data == null) {
        throw Exception('Product not found');
      }

      return ProductModel.fromMap(data, productId);
    } catch (e) {
      throw Exception('Failed to load product: ${e.toString()}');
    }
  }
}

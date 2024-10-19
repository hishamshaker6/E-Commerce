import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/cart_model.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/auth_services.dart';
import 'package:onlinestore/services/cart_services.dart';
import 'package:onlinestore/services/product_details_services.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  final productDetailsServices = ProductDetailsServicesImpl();
  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  String size = 's';

  String documentIdFromLocalData() => DateTime.now().toIso8601String();

  Future<void> getProductDetails(String productId, String categoryType) async {
    emit(ProductDetailsLoading());
    try {
      final product = await productDetailsServices.getProductDetails(productId, categoryType);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> addToCart(ProductModel product) async {
    final bool isSale = product.discountValue > 0;
    final num discountedPrice = isSale
        ? product.price - (product.price * (product.discountValue / 100))
        : product.price;

    emit(AddingToCart());
    try {
      final currentUser = authServices.currentUser;
      if (currentUser == null) {
        emit(AddToCartError('User not authenticated'));
        return;
      }

      if (size == 's') {
        emit(AddToCartError('Please select a size'));
        return;
      }

      final addToCartProduct = CartModel(
        id: documentIdFromLocalData(),
        title: product.title,
        price: discountedPrice,
        productId: product.id,
        imgUrl: product.imgUrl,
        size: size,
      );

      await cartServices.addProductToCart(currentUser.uid, addToCartProduct);
      emit(AddedToCart());
    } catch (e) {
      emit(AddToCartError(e.toString()));
    }
  }

  void setSize(String newSize) {
    size = newSize;
    emit(SizeSelected(newSize));
  }
}

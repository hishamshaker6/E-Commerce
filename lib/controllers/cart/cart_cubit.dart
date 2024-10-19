import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/cart_model.dart';
import 'package:onlinestore/services/auth_services.dart';
import 'package:onlinestore/services/cart_services.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final authServices = AuthServicesImpl();
  final cartServices = CartServicesImpl();

  List<CartModel> cartProducts = [];

  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser;

      if (currentUser == null) {
        emit(CartError('User not authenticated'));
        return;
      }

      cartProducts = await cartServices.getCartProducts(currentUser.uid);
      final totalAmount = cartProducts.fold<double>(
          0, (previousValue, element) => previousValue + element.price * element.quantity);

      emit(CartLoaded(cartProducts, totalAmount));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> removeProductFromCart(String productId) async {
    final currentUser = authServices.currentUser;

    if (currentUser == null) {
      emit(CartError('User not authenticated'));
      return;
    }

    try {
      await cartServices.removeProductFromCart(currentUser.uid, productId);
      cartProducts.removeWhere((item) => item.id == productId);
      final newTotal = cartProducts.fold<double>(
          0, (previousValue, element) => previousValue + (element.price * element.quantity));

      emit(CartLoaded(cartProducts, newTotal));
    } catch (e) {
      emit(CartError('Failed to remove product: ${e.toString()}'));
    }
  }

  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    final currentUser = authServices.currentUser;

    if (currentUser == null) {
      emit(CartError('User not authenticated'));
      return;
    }

    try {
      final cartItem = cartProducts.firstWhere((item) => item.id == productId);
      cartItem.quantity = newQuantity;
      await cartServices.updateProductInCart(currentUser.uid, cartItem);
      final newTotal = cartProducts.fold<double>(
        0,
            (previousValue, element) => previousValue + (element.price * element.quantity),
      );

      emit(CartLoaded(cartProducts, newTotal));
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
    }
  }
}

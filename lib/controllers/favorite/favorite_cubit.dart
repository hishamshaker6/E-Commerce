import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/auth_services.dart';
import 'package:onlinestore/services/favorite_services.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final authServices = AuthServicesImpl();
  final favoriteServices = FavoriteServicesImpl();

  Future<void> getFavoriteItems() async {
    emit(FavoriteLoading());
    try {
      final currentUser = authServices.currentUser;

      if (currentUser == null) {
        emit(FavoriteError('User not authenticated'));
        return;
      }

      final favoriteProducts = await favoriteServices.getFavoriteProducts(currentUser.uid);

      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: ${e.toString()}'));
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    try {
      final currentUser = authServices.currentUser;
      if (currentUser == null) {
        emit(FavoriteError('User not authenticated'));
        return;
      }

      final isFavorite = state is FavoriteLoaded &&
          (state as FavoriteLoaded).favoriteProducts.any((p) => p.id == product.id);

      if (isFavorite) {
        await favoriteServices.removeProductFromFavorites(currentUser.uid, product.id);
        final updatedFavorites = (state as FavoriteLoaded)
            .favoriteProducts
            .where((p) => p.id != product.id)
            .toList();
        emit(FavoriteLoaded(updatedFavorites));
      } else {
        await favoriteServices.addProductToFavorites(currentUser.uid, product);
        final updatedFavorites = [...(state as FavoriteLoaded).favoriteProducts, product];
        emit(FavoriteLoaded(updatedFavorites));
      }
    } catch (e) {
      emit(FavoriteError('Failed to toggle favorite: ${e.toString()}'));
    }
  }
  Future<void> removeFavoriteItem(String productId) async {
    try {
      final currentUser = authServices.currentUser;
      if (currentUser == null) {
        emit(FavoriteError('User not authenticated'));
        return;
      }

      await favoriteServices.removeProductFromFavorites(currentUser.uid, productId);

      final updatedFavorites = (state as FavoriteLoaded)
          .favoriteProducts
          .where((p) => p.id != productId)
          .toList();
      emit(FavoriteLoaded(updatedFavorites));
    } catch (e) {
      emit(FavoriteError('Failed to remove favorite: ${e.toString()}'));
    }
  }
}

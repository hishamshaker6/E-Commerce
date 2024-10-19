part of 'favorite_cubit.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> favoriteProducts;

  FavoriteLoaded(this.favoriteProducts);
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}

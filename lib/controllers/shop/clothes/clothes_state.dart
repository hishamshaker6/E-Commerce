part of 'clothes_cubit.dart';

@immutable
sealed class ClothesState {}

final class ClothesInitial extends  ClothesState {}

final class ClothesLoading extends  ClothesState {}

final class ClothesSuccess extends  ClothesState {
  final List<ProductModel> clothes;

  ClothesSuccess({required this.clothes});
}

final class ClothesFailed extends ClothesState {
  final String error;

  ClothesFailed(this.error);
}
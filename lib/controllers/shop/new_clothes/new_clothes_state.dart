part of 'new_clothes_cubit.dart';

@immutable
sealed class NewClothesState {}

final class NewClothesInitial extends  NewClothesState {}

final class NewClothesLoading extends  NewClothesState {}

final class NewClothesSuccess extends  NewClothesState {
  final List<ProductModel> newClothes;

  NewClothesSuccess({required this.newClothes,});
}

final class NewClothesFailed extends NewClothesState {
  final String error;

  NewClothesFailed(this.error);
}
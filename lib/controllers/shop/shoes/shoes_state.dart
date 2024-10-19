part of 'shoes_cubit.dart';

@immutable
sealed class ShoesState {}

final class ShoesInitial extends ShoesState {}

final class ShoesLoading extends  ShoesState {}

final class ShoesSuccess extends  ShoesState {
  final List<ProductModel> shoes;

  ShoesSuccess({required this.shoes});
}

final class ShoesFailed extends ShoesState {
  final String error;

  ShoesFailed(this.error);
}
part of 'accessories_cubit.dart';

@immutable
sealed class AccessoriesState {}

final class AccessoriesInitial extends  AccessoriesState {}

final class AccessoriesLoading extends  AccessoriesState {}

final class AccessoriesSuccess extends  AccessoriesState {
  final List<ProductModel> accessories;

  AccessoriesSuccess({required this.accessories});
}

final class AccessoriesFailed extends AccessoriesState {
  final String error;

  AccessoriesFailed(this.error);
}
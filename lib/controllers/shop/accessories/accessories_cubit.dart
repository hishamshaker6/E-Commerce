import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/shop/accessories_services.dart';
part 'accessories_state.dart';

class AccessoriesCubit extends Cubit<AccessoriesState> {
  AccessoriesCubit() : super(AccessoriesInitial());

  final accessoriesServices = AccessoriesServicesImpl();

  Future<void> getAccessoriesContent() async {
    emit(AccessoriesLoading());
    try {
      final accessories = await accessoriesServices.getAccessories();
      if (!isClosed) {
        emit(AccessoriesSuccess(
          accessories:  accessories,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AccessoriesFailed(e.toString()));
      }
    }
  }
}
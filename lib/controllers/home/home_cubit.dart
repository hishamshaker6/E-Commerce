import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final HomeServicesImpl homeServices = HomeServicesImpl();

  Future<void> getHomeContent() async {
    if (isClosed) return;
    emit(HomeLoading());

    try {
      final newProducts = await homeServices.getNewProducts();
      final salesProducts = await homeServices.getSalesProducts();

      if (!isClosed) {
        emit(HomeSuccess(
          salesProducts: salesProducts,
          newProducts: newProducts,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(HomeFailed('Failed to fetch content: ${e.toString()}'));
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/shop/shoes_services.dart';


part 'shoes_state.dart';

class ShoesCubit extends Cubit< ShoesState> {
  ShoesCubit() : super( ShoesInitial());

  final shoesServices = ShoesServicesImpl();

  Future<void> getShoesContent() async {
    emit(ShoesLoading());
    try {
      final shoes = await shoesServices.getShoes();
      if (!isClosed) {
        emit(ShoesSuccess(
          shoes: shoes,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ShoesFailed(e.toString()));
      }
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/shop/new_clothes_services.dart';

part 'new_clothes_state.dart';

class NewClothesCubit extends Cubit<NewClothesState> {
  NewClothesCubit() : super(NewClothesInitial());

  final newClothesServices = NewClothesServicesImpl();

  Future<void> getNewClothesContent() async {
    emit(NewClothesLoading());
    try {
      final newClothes = await newClothesServices.getNewClothes();
      if (!isClosed) {
        emit(NewClothesSuccess(
          newClothes: newClothes,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(NewClothesFailed(e.toString()));
      }
    }
  }
}
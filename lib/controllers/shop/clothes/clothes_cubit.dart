import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/services/shop/clothes_services.dart';


part 'clothes_state.dart';

class ClothesCubit extends Cubit<ClothesState> {
  ClothesCubit() : super(ClothesInitial());

  final clothesServices = ClothesServicesImpl();

  Future<void> getClothesContent() async {
    emit(ClothesLoading());
    try {
      final clothes = await clothesServices.getClothes();
      if (!isClosed) {
        emit(ClothesSuccess(
          clothes: clothes,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ClothesFailed(e.toString()));
      }
    }
  }
}
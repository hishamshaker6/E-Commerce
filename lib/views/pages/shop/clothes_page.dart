import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/shop/clothes/clothes_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/list_item_widget.dart';
class ClothesPage extends StatelessWidget {
  const ClothesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ClothesCubit();
        cubit.getClothesContent();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sale Clothes',style: TextStyle(color: AppColors.textColorWhite),),
          centerTitle: true,
          backgroundColor: AppColors.colorRed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.colorWhite,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ClothesCubit, ClothesState>(
          buildWhen: (previous, current) =>
          current is ClothesSuccess ||
              current is ClothesLoading ||
              current is ClothesFailed,
          builder: (context, state) {
            if (state is ClothesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  color: AppColors.colorRed,
                ),
              );
            } else if (state is ClothesFailed) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is ClothesSuccess) {
              final clothes = state.clothes;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w,vertical: 10.h),
                child: GridView.builder(
                  padding: const EdgeInsets.all(6.0),
                  itemCount: clothes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.w,
                    mainAxisSpacing: 5.h,
                    mainAxisExtent: 325.h,
                  ),
                  itemBuilder: (_, i) =>Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorWhite,
                      borderRadius: BorderRadius.circular(10.0.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2.r,
                          blurRadius: 5.r,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListItemHome(
                      product: clothes[i],
                      isNew: false,
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

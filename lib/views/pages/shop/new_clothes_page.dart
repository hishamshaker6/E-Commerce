import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/shop/new_clothes/new_clothes_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/list_item_widget.dart';

class NewClothesPage extends StatelessWidget {
  const NewClothesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = NewClothesCubit();
        cubit.getNewClothesContent();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Clothes',style: TextStyle(color: AppColors.textColorWhite),),
          centerTitle: true,
          backgroundColor: AppColors.colorRed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.colorWhite,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<NewClothesCubit, NewClothesState>(
          buildWhen: (previous, current) =>
          current is NewClothesSuccess ||
              current is NewClothesLoading ||
              current is NewClothesFailed,
          builder: (context, state) {
            if (state is NewClothesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  color: AppColors.colorRed,
                ),
              );
            } else if (state is NewClothesFailed) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is NewClothesSuccess) {
              final newClothes = state.newClothes;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal:4.5.w,vertical: 10.h),
                child: GridView.builder(
                  padding:  EdgeInsets.all(6.0.h),
                  itemCount: newClothes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.w,
                    mainAxisSpacing: 5.h,
                    mainAxisExtent: 320.h,
                  ),
                  itemBuilder: (_, i) => Container(
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
                      product: newClothes[i],
                      isNew: true,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/shop/accessories/accessories_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/list_item_widget.dart';

class AccessoriesPage extends StatelessWidget {
  const AccessoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AccessoriesCubit();
        cubit.getAccessoriesContent();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accessories',style: TextStyle(color: AppColors.textColorWhite),),
          centerTitle: true,
          backgroundColor: AppColors.colorRed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.colorWhite,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<AccessoriesCubit, AccessoriesState>(
          buildWhen: (previous, current) =>
          current is AccessoriesSuccess ||
              current is AccessoriesLoading ||
              current is AccessoriesFailed,
          builder: (context, state) {
            if (state is AccessoriesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  color: AppColors.colorRed,
                ),
              );
            } else if (state is AccessoriesFailed) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is AccessoriesSuccess) {
              final accessories = state.accessories;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.h),
                child: GridView.builder(
                  padding: const EdgeInsets.all(6.0),
                  itemCount: accessories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.w,
                    mainAxisSpacing: 5.h,
                    mainAxisExtent: 325.h,
                  ),
                  itemBuilder: (_, i) => ListItemHome(
                    product: accessories[i],
                    isNew: false,
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

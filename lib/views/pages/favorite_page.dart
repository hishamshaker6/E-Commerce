import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/favorite/favorite_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';
import 'package:onlinestore/views/widgets/favorite_list_item.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    return Scaffold(
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return buildShimmerEffect(context,5);
          } else if (state is FavoriteLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
              child: RefreshIndicator(
                color: AppColors.colorRed,
                onRefresh: () async {
                  await favoriteCubit.getFavoriteItems();
                },
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0.h),
                          child: Text(
                            'My Favorite',
                            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 4.0.w),
                        Icon(Icons.favorite, size: 30.0.sp),
                      ],
                    ),
                    SizedBox(height: 16.0.h),
                    if (state.favoriteProducts.isEmpty)
                      const Center(
                        child: Text('No favorite products'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.favoriteProducts.length,
                        itemBuilder: (context, index) {
                          final product = state.favoriteProducts[index];
                          return FavoriteListItem(
                            favoriteItem: product,
                            onRemove: () {
                              favoriteCubit.removeFavoriteItem(product.id);
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

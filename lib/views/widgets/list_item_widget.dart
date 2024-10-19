import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/favorite/favorite_cubit.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';

class ListItemHome extends StatelessWidget {
  final ProductModel product;
  final bool isNew;

  const ListItemHome({
    super.key,
    required this.product,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSale = product.discountValue > 0;
    final num discountedPrice = isSale
        ? product.price - (product.price * (product.discountValue / 100))
        : product.price;

    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
        AppRoutes.productDetailsRoute,
        arguments: [product.id, product.categoryType],
      ),


    child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11.0.r),
            child: CachedNetworkImage(
              imageUrl: product.imgUrl,
              placeholder: (context, url) => buildShimmerEffect(context, 1),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 180.w,
              height: 180.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.0.h),
            child: SizedBox(
              width: 42.w,
              height: 25.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0.r),
                  color: isNew ? Colors.black : AppColors.colorRed,
                ),
                child: Center(
                  child: Text(
                    isNew ? 'NEW' : '${product.discountValue}%',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: AppColors.textColorWhite),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brandName,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.0.h),
                Row(
                  children: [
                    Text(
                      '\$${discountedPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.colorGreen,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0.w),
                    if (isSale)
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.colorGrey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 3.h,
            right: 1.w,
            child: SizedBox(
              height: 50.h,
              width: 50.w,
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  final favoriteCubit = context.read<FavoriteCubit>();

                  if (state is FavoriteLoaded) {
                    final isFavorite =
                    state.favoriteProducts.any((p) => p.id == product.id);
                    return Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 30.sp,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isFavorite ? Colors.redAccent : Colors.black45,
                        ),
                        onPressed: () {
                          favoriteCubit.toggleFavorite(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFavorite
                                  ? 'Removed from favorites'
                                  : 'Added to favorites'),
                              backgroundColor: isFavorite ? AppColors.colorRed : AppColors.colorGreen,
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is FavoriteLoading) {
                    return buildShimmerEffect(context, 1);
                  } else {
                    return IconButton(
                      iconSize: 37.sp,
                      icon: const Icon(Icons.error),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to load favorites'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

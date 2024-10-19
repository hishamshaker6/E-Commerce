import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onlinestore/controllers/favorite/favorite_cubit.dart';
import 'package:onlinestore/controllers/product_details/product_details_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';
import 'package:onlinestore/views/widgets/product_details/product_details_build.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final productDetailsCubit = BlocProvider.of<ProductDetailsCubit>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteCubit>(
          create: (context) {
            final favoriteCubit = FavoriteCubit();
            favoriteCubit.getFavoriteItems();
            return favoriteCubit;
          },
        ),
      ],
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        bloc: productDetailsCubit,
        buildWhen: (previous, current) =>
        current is ProductDetailsLoading ||
            current is ProductDetailsLoaded ||
            current is ProductDetailsError,
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(strokeWidth: 3.w, color: AppColors.colorRed)),
            );
          } else if (state is ProductDetailsError) {
            return Scaffold(
              body: Center(child: Text(state.error)),
            );
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;

            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.r),
                                bottomLeft: Radius.circular(20.r),
                              ),
                            ),
                            width: double.infinity,
                            height: 450.h,
                            child: CachedNetworkImage(
                              imageUrl: product.imgUrl,
                              placeholder: (context, url) => buildShimmerEffect(context, 1),
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                          Positioned(
                            left: 10.w,
                            child: IconButton(
                              iconSize: 25.sp,
                              icon: const Icon(Icons.arrow_back, color: AppColors.colorRed),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      buildProductDetailsSection(context, product, productDetailsCubit),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

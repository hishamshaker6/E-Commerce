import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/favorite/favorite_cubit.dart';
import 'package:onlinestore/controllers/product_details/product_details_cubit.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';
import 'package:onlinestore/views/widgets/main_button.dart';
import 'package:onlinestore/views/widgets/product_details/drop_down_menu.dart';

Widget buildProductDetailsSection(BuildContext context, ProductModel product, ProductDetailsCubit productDetailsCubit) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSizeAndFavoriteRow(product, productDetailsCubit),
        SizedBox(height: 22.0.h),
        buildProductTitleAndPrice(context, product),
        SizedBox(height: 5.0.h),
        Text(
          product.brandName,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontSize: 15.sp,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 16.0.h),
        buildProductDescription(product),
        SizedBox(height: 24.0.h),
        buildAddToCartButton(productDetailsCubit, product),
      ],
    ),
  );
}

Row buildSizeAndFavoriteRow(ProductModel product, ProductDetailsCubit productDetailsCubit) {
  List<String> sizeOptions = product.categoryType == 'shoes'
      ? ['39', '40', '41', '42', '43', '44']
      : ['S', 'M', 'L', 'XL', 'XXL'];

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: SizedBox(
          height: 60.h,
          child: DropDownMenuComponent(
            items: sizeOptions,
            hint: 'Size',
            onChanged: (String? newValue) {
              if (newValue != null) {
                productDetailsCubit.setSize(newValue);
              }
            },
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 60.h,
          padding: EdgeInsets.only(left: 80.w),
          child: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              final favoriteCubit = context.read<FavoriteCubit>();

              if (state is FavoriteLoaded) {
                final isFavorite = state.favoriteProducts.any((p) => p.id == product.id);
                return IconButton(
                  iconSize: 37.sp,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isFavorite ? Colors.redAccent : Colors.black45,
                  ),
                  onPressed: () {
                    favoriteCubit.toggleFavorite(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite ? 'Removed from favorites' : 'Added to favorites',
                        ),
                        backgroundColor: isFavorite ? AppColors.colorRed : AppColors.colorGreen,
                      ),
                    );
                  },
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
  );
}




Row buildProductTitleAndPrice(BuildContext context, ProductModel product) {
  final bool isSale = product.discountValue > 0;
  final num discountedPrice = isSale
      ? product.price - (product.price * (product.discountValue/ 100))
      : product.price;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        product.title,
        style: Theme
            .of(context)
            .textTheme
            .titleLarge!
            .copyWith(
          fontSize: 22.sp,
            fontWeight: FontWeight.bold),
      ),
      Column(
        children: [
          Text(
            '\$${discountedPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 21.sp,
              color: AppColors.colorGreen,
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
  );
}

Text buildProductDescription(ProductModel product) {
  return Text(
    product.description,
    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
  );
}

Widget buildAddToCartButton(ProductDetailsCubit productDetailsCubit,
    ProductModel product) {
  return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
    bloc: productDetailsCubit,
    listenWhen: (previous, current) =>
    current is AddedToCart || current is AddToCartError,
    listener: (context, state) {
      if (state is AddedToCart) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added to the cart!'),
            backgroundColor: AppColors.colorGreen,),);
      } else if (state is AddToCartError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error),
            backgroundColor: AppColors.colorRed,));

      }
    },
    builder: (context, state) {
      if (state is AddingToCart) {
        return MainButton(child: CircularProgressIndicator(strokeWidth: 3.w,color: AppColors.colorRed,));
      }
      return MainButton(
        text: 'Add to cart',
        onTap: () async => await productDetailsCubit.addToCart(product),
        hasCircularBorder: true,
      );
    },
  );
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';
import 'package:onlinestore/views/widgets/home/carousel_slider.dart';
import 'package:onlinestore/views/widgets/home/header_of_list.dart';
import 'package:onlinestore/views/widgets/list_item_widget.dart';

Widget buildLoadingIndicator() {
  return Center(
    child: SpinKitCubeGrid(
      color: Colors.red,
      size: 50.0.sp,
      duration: const Duration(seconds: 2),
    ),
  );
}

Widget buildErrorMessage(String error) {
  return Center(
    child: Text(error),
  );
}

Widget buildHomeContent(
    BuildContext context, List salesProducts, List newProducts) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderImage(context),
        SizedBox(height: 24.0.h),
        const MyCarouselSlider(),
        SizedBox(height: 24.0.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            children: [
              _buildProductSection(
                'Sale',
                'Super Summer Sale!!',
                salesProducts,
                false,
                () =>
                    Navigator.of(context).pushNamed(AppRoutes.clothesPageRoute),
              ),
              SizedBox(height: 12.0.h),
              _buildProductSection(
                'New',
                'Super New Products!!',
                newProducts,
                true,
                () => Navigator.of(context)
                    .pushNamed(AppRoutes.newClothesPageRoute),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildHeaderImage(BuildContext context) {
  return Stack(
    alignment: Alignment.bottomLeft,
    children: [
      CachedNetworkImage(
        imageUrl: AppAssets.homeImage,
        height: 355.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => buildShimmerEffect(context, 1),
        errorWidget: (context, url, error) {
          return const Icon(Icons.error);
        },
      ),
      Opacity(
        opacity: 0.3,
        child: Container(
          width: double.infinity,
          height: 90.h,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.0.w,
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Summer\n',
                style: TextStyle(
                  fontSize: 32.sp,
                  color: AppColors.textColorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Sale',
                style: TextStyle(
                  fontSize: 32.sp,
                  color: AppColors.textColorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildProductSection(String title, String description, List products,
    bool isNew, VoidCallback onTap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HeaderOfList(
        onTap: onTap,
        title: title,
        description: description,
      ),
      SizedBox(height: 8.0.h),
      SizedBox(
        height: 330.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (_, int index) => Padding(
            padding: EdgeInsets.all(6.0.h),
            child: Container(
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
                product: products[index],
                isNew: isNew,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/shop/build_category_tile.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
          padding: EdgeInsets.all(16.h),
          children: [
            Padding(
              padding:EdgeInsets.all(8.0.h),
              child: Row(
                children: [
                  Text('Shop',
                    style:TextStyle(fontSize: 37.sp,fontWeight: FontWeight.bold) ,),
                  SizedBox(width: 5.w,),
                  Icon(Icons.shopping_cart,size: 30.sp,)
                ],
              ),
            ),
            SizedBox(height: 15.h,),
            Container(
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                color: AppColors.colorRed,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Text(
                    'SUMMER SALES',
                    style: TextStyle(
                      color: AppColors.textColorWhite,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Up to 50% off',
                    style: TextStyle(
                      color: AppColors.textColorWhite,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            buildCategoryTile(
              title: 'New',
              imageUrl: AppAssets.newClothes,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.newClothesPageRoute);
              },
            ),
            buildCategoryTile(
              title: 'Clothes',
              imageUrl:AppAssets.clothes,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.clothesPageRoute);
              },
            ),
            buildCategoryTile(
              title: 'Shoes',
              imageUrl: AppAssets.shoes,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.shoesPageRoute);
              },
            ),
            buildCategoryTile(
              title: 'Accessories',
              imageUrl:AppAssets.accessories,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.accessoriesPageRoute);
              },
            ),
          ],
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect(BuildContext context,int itemCount ) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
    child: ListView(
      children: [
         SizedBox(height: 16.0.h),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 50.0.h,
            width: 100.0.w,
            decoration: BoxDecoration(
              color: AppColors.colorWhite,
              borderRadius: BorderRadius.circular(8.0.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1.r,
                  blurRadius: 5.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0.h),
        ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 100.0.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1.r,
                        blurRadius: 5.r,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

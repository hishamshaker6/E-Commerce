import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/colors.dart';

class PaymentComponent extends StatelessWidget {
  const PaymentComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.0.h),
            child: Image.network(
              AppAssets.mastercardIcon,
              fit: BoxFit.cover,
              height: 30.h,
            ),
          ),
        ),
        SizedBox(width: 16.0.w),
        const Text('**** **** **** 2718'),
      ],
    );
  }
}

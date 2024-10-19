import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/colors.dart';

class OrderSummaryComponent extends StatelessWidget {
  final String title;
  final double price;
  const OrderSummaryComponent({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.colorGrey,
          ),
        ),
        Text(
          '${price.toStringAsFixed(2)} \$',
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.colorGreen,
          ),
        ),
      ],
    );
  }
}

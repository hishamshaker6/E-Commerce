import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/models/delivery_model.dart';
import 'package:onlinestore/utilities/colors.dart';

class DeliveryMethodItem extends StatelessWidget {
  final DeliveryModel deliveryMethod;

  const DeliveryMethodItem({
    Key? key,
    required this.deliveryMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(color: AppColors.colorRed),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            deliveryMethod.imgUrl.isNotEmpty
                ? Image.network(
              deliveryMethod.imgUrl,
              fit: BoxFit.cover,
              height: 70.h,
            )
                : Container(
              height: 70.h,
              color: AppColors.colorGrey,
              child: const Center(child: Text('Image not available')),
            ),
            SizedBox(height: 6.0.h),
            Text(
              deliveryMethod.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: AppColors.colorRed,
              ),
            ),
            Text(
              '${deliveryMethod.days.isNotEmpty ? deliveryMethod.days : 'N/A'} days',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: AppColors.colorRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

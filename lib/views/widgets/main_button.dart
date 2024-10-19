import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/colors.dart';

class MainButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final Widget? child;
  final bool hasCircularBorder;
  MainButton({
    super.key,
    this.text,
    this.onTap,
    this.hasCircularBorder = false,
    this.child,
  }) {
    assert(text != null || child != null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: AppColors.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0.r),
          )

        ),
        child: text != null ? Text(
          text!,style: TextStyle(fontSize: 15.sp),
        ) : child,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/colors.dart';
class AppTheme{
  static ThemeData lightTheme=ThemeData(
      scaffoldBackgroundColor:AppColors.colorWhite,
      primaryColor: AppColors.colorRed,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.colorWhite,
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle:  TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(
            color: AppColors.colorGrey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(
            color: AppColors.colorGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(
            color: AppColors.colorGrey,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(
            color: AppColors.colorRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(
            color: AppColors.colorRed,
          ),
        ),
      ),

  );


}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/start_stacked_image.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: buildImageWithText(
                imageUrl: AppAssets.newCollection,
                text: 'New collection',
                textColor: AppColors.textColorWhite,
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: buildImageWithText(
                            imageUrl: AppAssets.summerSale,
                            text: 'Summer sale',
                            textColor:AppColors.textColorRed,
                          ),
                        ),
                        Expanded(
                          child: buildImageWithText(
                            imageUrl: AppAssets.blackCollection,
                            text: 'Black',
                            textColor:AppColors.textColorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: buildImageWithText(
                      imageUrl: AppAssets.menIsHoodies,
                      text: "Men's hoodies",
                      textColor:AppColors.textColorWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
              context, AppRoutes.loginPageRoute);
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.login,
          color: AppColors.colorWhite,
          size: 24.sp,
        ),
      ),
    );
  }
}


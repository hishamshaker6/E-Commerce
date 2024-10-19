import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';

class MyCarouselSlider extends StatelessWidget {
  const MyCarouselSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 210.0.h,
        viewportFraction: 0.83.w,
        autoPlay: false,
      ),
      items: [
        AppAssets.myCarouselSliderOne,
        AppAssets.myCarouselSliderTwo,
        AppAssets.myCarouselSliderThree,
        AppAssets.myCarouselSliderFour
      ].map((imageUrl) {
        return Padding(
          padding: EdgeInsets.all(8.0.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0.r),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5.0.w),
              decoration: const BoxDecoration(),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => buildShimmerEffect(context, 1),
                errorWidget: (context, url, error) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

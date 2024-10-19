import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';

Widget buildImageWithText({
  required String imageUrl,
  required String text,
  required Color textColor,
}) {
  return Stack(
    children: [
      Positioned.fill(
        child:CachedNetworkImage(
          imageUrl: imageUrl,fit: BoxFit.cover,
          placeholder: (context, url) => buildShimmerEffect(context,2),
          errorWidget: (context, url, error) {
            return const Icon(Icons.error);
          },
        ),
      ),
      Positioned(
        bottom: 70.0.h,
        left: 16.0.w,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 25.0.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    ],
  );
}

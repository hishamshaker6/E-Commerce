import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/models/product.dart';
import 'package:onlinestore/utilities/colors.dart';

class FavoriteListItem extends StatelessWidget {
  final ProductModel favoriteItem;
  final VoidCallback onRemove;

  const FavoriteListItem({
    Key? key,
    required this.favoriteItem,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0.r),
                bottomLeft: Radius.circular(16.0.r),
              ),
              child: CachedNetworkImage(
                imageUrl: favoriteItem.imgUrl,
                placeholder: (context, url) => CircularProgressIndicator(
                  strokeWidth: 3.w,
                  color: AppColors.colorRed,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 100.w,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favoriteItem.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
              
                      fontWeight: FontWeight.bold,
              
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    favoriteItem.brandName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
              
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.favorite,
                          color: AppColors.colorRed,
                          size: 30.sp,
                        ),
                      ),
                    ),
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

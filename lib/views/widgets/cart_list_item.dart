import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/models/cart_model.dart';
import 'package:onlinestore/utilities/colors.dart';

class CartListItem extends StatelessWidget {
  final CartModel cartItem;
  final VoidCallback onRemove;
  final Function(int) onUpdateQuantity;

  const CartListItem({
    Key? key,
    required this.cartItem,
    required this.onRemove,
    required this.onUpdateQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165.h,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0.r),
                bottomLeft: Radius.circular(16.0.r),
              ),
              child: CachedNetworkImage(
                imageUrl: cartItem.imgUrl,
                placeholder: (context, url) => CircularProgressIndicator(
                  strokeWidth: 3.w,
                  color: AppColors.colorRed,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120.w,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 8.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cartItem.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: onRemove,
                          icon: Icon(
                            Icons.delete,
                            color: AppColors.colorRed,
                            size: 27.sp,
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Size: ',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.grey),
                          ),
                          TextSpan(
                            text: cartItem.size,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30.0.w,
                              height: 30.0.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.colorRed,
                              ),
                              child: ClipOval(
                                child: Material(
                                  color: AppColors.colorRed,
                                  child: IconButton(
                                    onPressed: () {
                                      if (cartItem.quantity > 1) {
                                        onUpdateQuantity(cartItem.quantity - 1);
                                      }
                                    },
                                    icon: const Icon(Icons.remove,
                                        color: AppColors.colorWhite),
                                    padding: EdgeInsets.zero,
                                    iconSize: 20.0.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              cartItem.quantity.toString(),
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Container(
                              width: 30.0.w,
                              height: 30.0.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.colorRed,
                              ),
                              child: ClipOval(
                                child: Material(
                                  color: AppColors.colorRed,
                                  child: IconButton(
                                    onPressed: () {
                                      onUpdateQuantity(cartItem.quantity + 1);
                                    },
                                    icon: const Icon(Icons.add,
                                        color: AppColors.colorWhite),
                                    padding: EdgeInsets.zero,
                                    iconSize: 20.0.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 75.w,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${cartItem.price}\$',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

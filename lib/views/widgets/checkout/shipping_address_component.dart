import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/address_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';

class ShippingAddressComponent extends StatelessWidget {
  final AddressModel shippingAddress;
  final CheckoutCubit checkoutCubit;

  const ShippingAddressComponent({
    super.key,
    required this.shippingAddress,
    required this.checkoutCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
      child: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shippingAddress.fullName,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.shippingAddressesRoute,
                    arguments: checkoutCubit,
                  ),
                  child: Text(
                    'Change',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.textColorRed,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            Text(
              shippingAddress.address,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${shippingAddress.city}, ${shippingAddress.state}, ${shippingAddress.country}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

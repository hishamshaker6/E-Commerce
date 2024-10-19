import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/address_model.dart';
import 'package:onlinestore/models/args_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';

class ShippingAddressStateItem extends StatefulWidget {
  final AddressModel shippingAddress;

  const ShippingAddressStateItem({
    super.key,
    required this.shippingAddress,
  });

  @override
  State<ShippingAddressStateItem> createState() =>
      _ShippingAddressStateItemState();
}

class _ShippingAddressStateItemState extends State<ShippingAddressStateItem> {
  late bool checkedValue;

  @override
  void initState() {
    super.initState();
    checkedValue = widget.shippingAddress.isDefault;
  }

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

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
                  widget.shippingAddress.fullName,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.addShippingAddressRoute,
                    arguments: AddShippingAddressArgs(
                        shippingAddress: widget.shippingAddress,
                        checkoutCubit: checkoutCubit),
                  ),
                  child: Text(
                    'Edit',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.textColorRed,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            Text(
              widget.shippingAddress.address,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${widget.shippingAddress.city}, ${widget.shippingAddress.state}, ${widget.shippingAddress.country}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            CheckboxListTile(
              title: const Text("Default shipping address"),
              value: checkedValue,
              onChanged: (newValue) async {
                setState(() {
                  checkedValue = newValue!;
                });
                final newAddress =
                    widget.shippingAddress.copyWith(isDefault: newValue);
                await checkoutCubit.saveAddress(newAddress);
              },
              activeColor: Colors.black,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            )
          ],
        ),
      ),
    );
  }
}

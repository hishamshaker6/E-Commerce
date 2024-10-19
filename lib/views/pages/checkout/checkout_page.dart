import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/address_model.dart';
import 'package:onlinestore/models/args_model.dart';
import 'package:onlinestore/models/delivery_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/checkout/checkout_order_details.dart';
import 'package:onlinestore/views/widgets/checkout/delivery_method_item.dart';
import 'package:onlinestore/views/widgets/checkout/payment_component.dart';
import 'package:onlinestore/views/widgets/checkout/shipping_address_component.dart';
import 'package:onlinestore/views/widgets/main_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  late CheckoutCubit checkoutCubit;

  @override
  void initState() {
    super.initState();
    checkoutCubit = BlocProvider.of<CheckoutCubit>(context);
  }

  Widget shippingAddressComponent(AddressModel? shippingAddress) {
    if (shippingAddress == null) {
      return Center(
        child: Column(
          children: [
            const Text('No Shipping Addresses!'),
            SizedBox(height: 6.0.h),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.addShippingAddressRoute,
                arguments: AddShippingAddressArgs(
                  checkoutCubit: checkoutCubit,
                  shippingAddress: shippingAddress,
                ),
              ),
              child: Text(
                'Add new one',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      );
    } else {
      return ShippingAddressComponent(
        shippingAddress: shippingAddress,
        checkoutCubit: checkoutCubit,
      );
    }
  }

  Widget deliveryMethodsComponent(List<DeliveryModel> deliveryMethods) {
    if (deliveryMethods.isEmpty) {
      return const Center(
        child: Text('No delivery methods available!'),
      );
    }

    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        itemCount: deliveryMethods.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.all(8.0.h),
          child: DeliveryMethodItem(deliveryMethod: deliveryMethods[i]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.colorWhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.colorRed,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.colorWhite,
          ),
        ),
      ),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        bloc: checkoutCubit,
        buildWhen: (previous, current) =>
        current is CheckoutLoading ||
            current is CheckoutLoaded ||
            current is CheckoutLoadingFailed,
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.w,
                color: AppColors.colorRed,
              ),
            );
          } else if (state is CheckoutLoadingFailed) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is CheckoutLoaded) {
            final shippingAddress = state.addressModel;
            final deliveryMethods = state.deliveryModel;
            final totalAmount = state.totalAmount;

            return Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 32.0.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    shippingAddressComponent(shippingAddress),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.paymentMethodsRoute);
                          },
                          child: Text(
                            'Change',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: AppColors.textColorRed),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 8.0.h),
                    const PaymentComponent(),
                    SizedBox(height: 24.0.h),
                    Text(
                      'Delivery method',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0.h),
                    deliveryMethodsComponent(deliveryMethods),
                     SizedBox(height: 32.0.h),
                    CheckoutOrderDetails(
                      deliveryMethods: deliveryMethods,
                      totalAmount: totalAmount,
                    ),
                     SizedBox(height: 64.0.h),
                    BlocConsumer<CheckoutCubit, CheckoutState>(
                      bloc: checkoutCubit,
                      listenWhen: (previous, current) =>
                      current is PaymentMakingFailed ||
                          current is PaymentMade ||
                          current is PaymentCanceled,
                      listener: (context, state) {
                        if (state is PaymentMakingFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else if (state is PaymentMade) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        } else if (state is PaymentCanceled) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment canceled by user'),
                              backgroundColor: AppColors.colorRed,
                            ),
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                      current is PaymentMade ||
                          current is PaymentMakingFailed ||
                          current is PaymentCanceled ||
                          current is MakingPayment,
                      builder: (context, state) {
                        if (state is MakingPayment) {
                          return MainButton(
                            hasCircularBorder: true,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.w,
                              color: AppColors.colorRed,
                            ),
                          );
                        }

                        return MainButton(
                          text: 'Submit Order',
                          onTap: () async => await checkoutCubit.makePayment(),
                          hasCircularBorder: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}



Widget shippingAddressComponent(AddressModel? shippingAddress,
    BuildContext context) {
  if (shippingAddress == null) {
    return Center(
      child: Column(
        children: [
          const Text('No Shipping Addresses!'),
          SizedBox(height: 6.0.h),
          InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed(
                  AppRoutes.addShippingAddressRoute,
                  arguments: AddShippingAddressArgs(
                    checkoutCubit: context.read<CheckoutCubit>(),
                    shippingAddress: shippingAddress,
                  ),
                ),
            child: Text(
              'Add new one',
              style: Theme
                  .of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: AppColors.textColorRed),
            ),
          ),
        ],
      ),
    );
  } else {
    return ShippingAddressComponent(
      shippingAddress: shippingAddress,
      checkoutCubit: context.read<CheckoutCubit>(),
    );
  }
}

Widget deliveryMethodsComponent(List<DeliveryModel> deliveryMethods) {
  if (deliveryMethods.isEmpty) {
    return const Center(
      child: Text('No delivery methods available!'),
    );
  }
  return SizedBox(
    height: 200.h,
    child: ListView.builder(
      itemCount: deliveryMethods.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, i) =>
          Padding(
            padding: EdgeInsets.all(8.0.h),
            child: DeliveryMethodItem(deliveryMethod: deliveryMethods[i]),
          ),
    ),
  );
}


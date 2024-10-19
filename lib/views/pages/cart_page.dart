import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/cart/cart_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/build_shimmer_effect.dart';
import 'package:onlinestore/views/widgets/cart_list_item.dart';
import 'package:onlinestore/views/widgets/main_button.dart';
import 'package:onlinestore/views/widgets/order_summary_component.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCubit = BlocProvider.of<CartCubit>(context);
    return SafeArea(
      child: BlocBuilder<CartCubit, CartState>(
        bloc: cartCubit,
        buildWhen: (previous, current) =>
        current is CartLoaded || current is CartLoading || current is CartError,
        builder: (context, state) {
          if (state is CartLoading) {
            return buildShimmerEffect(context, 5);
          } else if (state is CartLoaded) {
            final totalAmount = state.totalAmount;
            final cartProducts = state.cartProducts;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
              child: RefreshIndicator(
                color: AppColors.colorRed,
                onRefresh: () async {
                  await cartCubit.getCartItems();
                },
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0.h),
                          child: Text(
                            'My Cart',
                            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 4.0.w),
                         Icon(Icons.shopping_bag, size: 30.0.sp),
                      ],
                    ),
                    SizedBox(height: 16.0.h),
                    if (cartProducts.isEmpty)
                      Center(
                        child: Text(
                          'No Data Available!',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: cartProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          final cartItem = cartProducts[i];
                          return CartListItem(
                            cartItem: cartItem,
                            onRemove: () => cartCubit.removeProductFromCart(cartItem.id),
                            onUpdateQuantity: (newQuantity) {
                              context.read<CartCubit>().updateProductQuantity(cartItem.id, newQuantity);
                            },
                          );
                        },
                      ),
                    SizedBox(height: 24.0.h),
                    OrderSummaryComponent(
                      title: 'Total Amount',
                      price: totalAmount,
                    ),
                    SizedBox(height: 32.0.h),
                    MainButton(
                      text: 'Checkout',
                      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.checkoutPageRoute,
                        arguments: totalAmount,
                      ),

                      hasCircularBorder: true,
                    ),
                    SizedBox(height: 42.0.h),
                  ],
                ),
              ),
            );
          } else if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.labelMedium,
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

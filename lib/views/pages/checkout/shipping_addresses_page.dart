import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/args_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/checkout/shipping_address_state_item.dart';


class ShippingAddressesPage extends StatefulWidget {
  const ShippingAddressesPage({super.key});

  @override
  State<ShippingAddressesPage> createState() => _ShippingAddressesPageState();
}

class _ShippingAddressesPageState extends State<ShippingAddressesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CheckoutCubit>(context).getShippingAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Addresses',style: TextStyle(color: AppColors.textColorWhite),),
        centerTitle: true,
        backgroundColor: AppColors.colorRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: AppColors.colorWhite,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 16.0.h),
          child: BlocBuilder<CheckoutCubit, CheckoutState>(
            bloc: checkoutCubit,
            buildWhen: (previous, current) =>
            current is FetchingAddresses ||
                current is AddressesFetched ||
                current is AddressesFetchingFailed,
            builder: (context, state) {
              if (state is FetchingAddresses) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is AddressesFetchingFailed) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is AddressesFetched) {
                final shippingAddresses = state.shippingAddresses;

                return Column(
                  children: shippingAddresses
                      .map(
                        (shippingAddress) => ShippingAddressStateItem(
                      shippingAddress: shippingAddress,
                    ),
                  )
                      .toList(),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          AppRoutes.addShippingAddressRoute,
          arguments: AddShippingAddressArgs(
            checkoutCubit: checkoutCubit,
          ),
        ),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
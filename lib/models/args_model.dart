
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/address_model.dart';

class AddShippingAddressArgs {
  final AddressModel? shippingAddress;
  final CheckoutCubit checkoutCubit;

  AddShippingAddressArgs({this.shippingAddress, required this.checkoutCubit,});
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/address_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/main_button.dart';
import 'package:onlinestore/views/widgets/main_dialog.dart';


class AddShippingAddressPage extends StatefulWidget {
  final AddressModel? shippingAddress;
  const AddShippingAddressPage({super.key, this.shippingAddress});

  @override
  State<AddShippingAddressPage> createState() => _AddShippingAddressPageState();
}

class _AddShippingAddressPageState extends State<AddShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  AddressModel? shippingAddress;
  String documentIdFromLocalData() => DateTime.now().toIso8601String();


  @override
  void initState() {
    super.initState();
    shippingAddress = widget.shippingAddress;
    if (shippingAddress != null) {
      _fullNameController.text = shippingAddress!.fullName;
      _addressController.text = shippingAddress!.address;
      _cityController.text = shippingAddress!.city;
      _stateController.text = shippingAddress!.state;
      _zipCodeController.text = shippingAddress!.zipCode;
      _countryController.text = shippingAddress!.country;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> saveAddress(CheckoutCubit checkoutCubit) async {
    try {
      if (_formKey.currentState!.validate()) {
        final address = AddressModel(
          id: shippingAddress != null
              ? shippingAddress!.id
              : documentIdFromLocalData(),
          fullName: _fullNameController.text.trim(),
          country: _countryController.text.trim(),
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          zipCode: _zipCodeController.text.trim(),
        );
        await checkoutCubit.saveAddress(address);
        if (!mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      MainDialog(
          context: context,
          title: 'Error Saving Address',
          content: e.toString())
          .showAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          shippingAddress != null
              ? 'Editing Shipping Address'
              : 'Adding Shipping Address',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
             EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 16.0.w),
            child: Column(
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    fillColor:AppColors.textColorWhite,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your name',
                ),
                 SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    fillColor:AppColors.textColorWhite,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your name',
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    fillColor:AppColors.textColorWhite,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your name',
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State/Province',
                    fillColor:AppColors.textColorWhite,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your name',
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Zip Code',
                    fillColor:AppColors.textColorWhite,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your name',
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    fillColor:AppColors.textColorWhite,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your name',
                ),
                SizedBox(height: 32.0.h),
                MainButton(
                  text: 'Save Address',
                  onTap: () => saveAddress(checkoutCubit),
                  hasCircularBorder: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
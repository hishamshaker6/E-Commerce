import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/payment_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/main_button.dart';

class AddNewCardBottomSheet extends StatefulWidget {
  final PaymentModel? paymentMethod;

  const AddNewCardBottomSheet({super.key, this.paymentMethod});

  @override
  State<AddNewCardBottomSheet> createState() => _AddNewCardBottomSheetState();
}

class _AddNewCardBottomSheetState extends State<AddNewCardBottomSheet> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameOnCardController,
      _expireDateController,
      _cardNumberController,
      _cvvController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameOnCardController = TextEditingController();
    _expireDateController = TextEditingController();
    _cardNumberController = TextEditingController();
    _cvvController = TextEditingController();

    if (widget.paymentMethod != null) {
      _nameOnCardController.text = widget.paymentMethod!.name;
      _expireDateController.text = widget.paymentMethod!.expiryDate;
      _cardNumberController.text = widget.paymentMethod!.cardNumber;
      _cvvController.text = widget.paymentMethod!.cvv;
    }
  }

  @override
  void dispose() {
    _nameOnCardController.dispose();
    _expireDateController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

    return SizedBox(
      height: size.height * 0.8,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 24.0.h),
            Text(
              'Add New Card',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 15.0.h),
            _buildTextField(
                _nameOnCardController, 'Name on Card', TextInputType.name),
            SizedBox(height: 15.0.h),
            _buildTextField(
                _cardNumberController, 'Card Number', TextInputType.number),
            SizedBox(height: 15.0.h),
            _buildTextField(
                _expireDateController, 'Expire Date', TextInputType.datetime),
            SizedBox(height: 15.0.h),
            _buildTextField(_cvvController, 'CVV', TextInputType.number),
            SizedBox(height: 36.0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: BlocConsumer<CheckoutCubit, CheckoutState>(
                bloc: checkoutCubit,
                listenWhen: (previous, current) =>
                    current is CardsAdded || current is CardsAddingFailed,
                listener: (context, state) {
                  if (state is CardsAdded) {
                    Navigator.pop(context);
                  } else if (state is CardsAddingFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.error),
                          backgroundColor: AppColors.colorRed),
                    );
                  } else if (state is PaymentCanceled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text('Payment canceled. Please try again!'),
                        action: SnackBarAction(
                          label: 'Retry',
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is AddingCards ||
                    current is CardsAdded ||
                    current is CardsAddingFailed,
                builder: (context, state) {
                  if (state is AddingCards) {
                    return MainButton(
                      onTap: null,
                      child: const CircularProgressIndicator.adaptive(),
                    );
                  }
                  return MainButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final paymentMethod = PaymentModel(
                          id: widget.paymentMethod != null
                              ? widget.paymentMethod!.id
                              : DateTime.now().toIso8601String(),
                          name: _nameOnCardController.text,
                          cardNumber: _cardNumberController.text,
                          expiryDate: _expireDateController.text,
                          cvv: _cvvController.text,
                        );
                        await checkoutCubit.addCard(paymentMethod);
                      }
                    },
                    text:
                        widget.paymentMethod != null ? 'Edit Card' : 'Add Card',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType keyboardType) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value != null && value.isEmpty
            ? 'Please enter your $labelText'
            : null,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: AppColors.colorRed),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

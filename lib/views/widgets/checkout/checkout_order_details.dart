import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/views/widgets/order_summary_component.dart';
import 'package:onlinestore/models/delivery_model.dart';

class CheckoutOrderDetails extends StatefulWidget {
  final List<DeliveryModel> deliveryMethods;
  final double totalAmount;

  const CheckoutOrderDetails({
    Key? key,
    required this.deliveryMethods,
    required this.totalAmount,
  }) : super(key: key);

  @override
  CheckoutOrderDetailsState createState() => CheckoutOrderDetailsState();
}

class CheckoutOrderDetailsState extends State<CheckoutOrderDetails> {
  DeliveryModel? selectedDeliveryMethod;
  double deliveryPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<DeliveryModel>(
          hint: const Text("Choose the delivery company"),
          value: selectedDeliveryMethod,
          items: widget.deliveryMethods.map((deliveryMethod) {
            return DropdownMenuItem<DeliveryModel>(
              value: deliveryMethod,
              child: Text(deliveryMethod.name),
            );
          }).toList(),
          onChanged: (DeliveryModel? value) {
            setState(() {
              selectedDeliveryMethod = value;
              deliveryPrice = (selectedDeliveryMethod?.price ?? 0.0).toDouble();
            });
          },
        ),
        SizedBox(height: 8.0.h),
        OrderSummaryComponent(title: 'Order', price: widget.totalAmount),
        SizedBox(height: 8.0.h),
        OrderSummaryComponent(title: 'Delivery', price: deliveryPrice),
        SizedBox(height: 8.0.h),
        OrderSummaryComponent(
          title: 'Summary',
          price: widget.totalAmount + deliveryPrice, // Calculate total price
        ),
      ],
    );
  }
}

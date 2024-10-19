import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/models/payment_model.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/checkout/add_new_card_bottom_sheet.dart';
import 'package:onlinestore/views/widgets/main_button.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

    Future<void> showBottomSheet([PaymentModel? paymentMethod]) async {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return BlocProvider.value(
              value: checkoutCubit,
              child: AddNewCardBottomSheet(paymentMethod: paymentMethod),
            );
          }).then((value) => checkoutCubit.fetchCards());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods',style: TextStyle(color: AppColors.textColorWhite),),
        centerTitle: true,
        backgroundColor: AppColors.colorRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: AppColors.colorWhite,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        bloc: checkoutCubit,
        listenWhen: (previous, current) =>
            current is PreferredMade || current is PreferredMakingFailed,
        listener: (context, state) {
          if (state is PreferredMade) {
            Navigator.of(context).pop();
          } else if (state is PreferredMakingFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.colorRed,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is FetchingCards ||
            current is CardsFetched ||
            current is CardsFetchingFailed,
        builder: (context, state) {
          if (state is FetchingCards) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is CardsFetchingFailed) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is CardsFetched) {
            final paymentMethods = state.paymentModel;

            return SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 24.0.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your payment cards',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                     SizedBox(height: 16.0.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, index) {
                        final paymentMethod = paymentMethods[index];

                        return Padding(
                          padding:  EdgeInsets.only(bottom: 4.h),
                          child: InkWell(
                            onTap: () async {
                              await checkoutCubit.makePreferred(paymentMethod);
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0.w,
                                  vertical: 8.0.h,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.credit_card),
                                         SizedBox(width: 8.0.w),
                                        Text(paymentMethod.cardNumber),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            showBottomSheet(paymentMethod);
                                          },
                                        ),
                                        BlocBuilder<CheckoutCubit,
                                            CheckoutState>(
                                          bloc: checkoutCubit,
                                          buildWhen: (previous, current) =>
                                              (current is DeletingCards &&
                                                  current.paymentId ==
                                                      paymentMethod.id) ||
                                              current is CardsDeleted ||
                                              current is CardsDeletingFailed,
                                          builder: (context, state) {
                                            if (state is DeletingCards) {
                                              return  CircularProgressIndicator(
                                                strokeWidth: 3.w,
                                                color: AppColors.colorRed,
                                              );

                                            }
                                            return IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                await checkoutCubit
                                                    .deleteCard(paymentMethod);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                     SizedBox(height: 16.0.h),
                    MainButton(
                      onTap: () {
                        showBottomSheet();
                      },
                      text: 'Add New Card',
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

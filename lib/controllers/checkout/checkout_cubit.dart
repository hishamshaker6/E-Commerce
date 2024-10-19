import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlinestore/models/address_model.dart';
import 'package:onlinestore/models/delivery_model.dart';
import 'package:onlinestore/models/payment_model.dart';
import 'package:onlinestore/services/auth_services.dart';
import 'package:onlinestore/services/checkout_services.dart';
import 'package:onlinestore/services/stripe_services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({required this.totalAmount}) : super(CheckoutInitial());


  final CheckoutServicesImpl checkoutServices = CheckoutServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();
  final StripeServices stripeServices = StripeServices.instance;
  final double totalAmount;

  Future<void> makePayment() async {
    emit(MakingPayment());

    try {
      await stripeServices.makePayment(totalAmount, 'usd'); //
      emit(PaymentMade());
    } catch (e) {
      debugPrint(e.toString());
      if (e.toString().contains('Payment canceled by user')) {
        emit(PaymentCanceled());
      } else {
        emit(PaymentMakingFailed(e.toString()));
      }
    }
  }

  Future<void> addCard(PaymentModel paymentModel) async {
    emit(AddingCards());

    try {
      await checkoutServices.setPaymentMethod(paymentModel);
      emit(CardsAdded());
    } catch (e) {
      emit(CardsAddingFailed(e.toString()));
    }
  }

  Future<void> deleteCard(PaymentModel paymentModel) async {
    emit(DeletingCards(paymentModel.id));

    try {
      await checkoutServices.deletePaymentMethod(paymentModel);
      emit(CardsDeleted());
      await fetchCards();
    } catch (e) {
      emit(CardsDeletingFailed(e.toString()));
    }
  }

  Future<void> fetchCards() async {
    emit(FetchingCards());

    try {
      final paymentMethods = await checkoutServices.paymentModel();
      emit(CardsFetched(paymentMethods));
    } catch (e) {
      emit(CardsFetchingFailed(e.toString()));
    }
  }

  Future<void> makePreferred(PaymentModel paymentModel) async {
    emit(MakingPreferred());

    try {
      final preferredPaymentMethods = await checkoutServices.paymentModel(true);

      for (var method in preferredPaymentMethods) {
        final newPaymentMethod = method.copyWith(isPreferred: false);
        await checkoutServices.setPaymentMethod(newPaymentMethod);
      }

      final newPreferredMethod = paymentModel.copyWith(isPreferred: true);
      await checkoutServices.setPaymentMethod(newPreferredMethod);
      emit(PreferredMade());
    } catch (e) {
      emit(PreferredMakingFailed(e.toString()));
    }
  }

  Future<void> getCheckoutData() async {
    emit(CheckoutLoading());

    try {
      final currentUser = authServices.currentUser;
      final shippingAddresses = await checkoutServices.addressModel(currentUser!.uid);
      final deliveryMethods = await checkoutServices.deliveryMethods();

      emit(CheckoutLoaded(
        deliveryModel: deliveryMethods,
        addressModel: shippingAddresses.isEmpty ? null : shippingAddresses[0],
        totalAmount: totalAmount,
      ));
    } catch (e) {
      emit(CheckoutLoadingFailed(e.toString()));
    }
  }

  Future<void> getShippingAddresses() async {
    emit(FetchingAddresses());

    try {
      final currentUser = authServices.currentUser;
      final shippingAddresses = await checkoutServices.addressModel(currentUser!.uid);
      emit(AddressesFetched(shippingAddresses));
    } catch (e) {
      emit(AddressesFetchingFailed(e.toString()));
    }
  }

  Future<void> saveAddress(AddressModel address) async {
    emit(AddingAddress());

    try {
      final currentUser = authServices.currentUser;
      await checkoutServices.saveAddress(currentUser!.uid, address);
      emit(AddressAdded());
    } catch (e) {
      emit(AddressAddingFailed(e.toString()));
    }
  }

  Future<void> cancelPayment() async {
    try {
      await stripeServices.cancelPayment();
      emit(PaymentCanceled());
    } catch (e) {
      emit(PaymentMakingFailed(e.toString()));
    }
  }
}

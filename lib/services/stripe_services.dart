import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onlinestore/utilities/constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeServices {
  StripeServices._();

  static final StripeServices instance = StripeServices._();

  Future<void> makePayment(double amount, String currency) async {
    try {
      final clientSecret = await _createPaymentIntent(amount, currency);
      if (clientSecret == null) {
        throw Exception('Error: Client secret is null.');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'E-commerce App',
          style: ThemeMode.system,
        ),
      );

      try {
        await Stripe.instance.presentPaymentSheet();
        debugPrint('Payment successful');
      } catch (e) {
        if (e is StripeException) {
          debugPrint('Payment canceled: ${e.error.localizedMessage}');
          throw Exception('Payment canceled by user');
        } else {
          debugPrint('Error presenting payment sheet: ${e.toString()}');
          throw Exception('Error presenting payment sheet: ${e.toString()}');
        }
      }
    } catch (e) {
      if (e is StripeException) {
        debugPrint('Stripe error: ${e.error.localizedMessage}');
      } else {
        debugPrint('Make Payment: ${e.toString()}');
      }
      throw Exception('Error making payment: ${e.toString()}');
    }
  }

  Future<void> cancelPayment() async {
    try {
      debugPrint('Payment canceled by user');
    } catch (e) {
      debugPrint('Error canceling payment: ${e.toString()}');
      throw Exception('Error canceling payment: ${e.toString()}');
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final dio = Dio();
      final body = {
        'amount': _getFinalAmount(amount),
        'currency': currency,
      };

      final headers = {
        'Authorization': 'Bearer ${AppConstants.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final response = await dio.post(
        AppConstants.paymentIntentPath,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: headers,
        ),
      );

      if (response.data != null && response.data['client_secret'] != null) {
        debugPrint(response.data.toString());
        return response.data['client_secret'];
      } else {
        throw Exception('Error: Invalid response data');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('Dio error response: ${e.response!.data}');
      } else {
        debugPrint('Dio error request: ${e.requestOptions}');
      }
      throw Exception('Error creating payment intent: ${e.message}');
    } catch (e) {
      debugPrint('Create Payment Intent: ${e.toString()}');
      throw Exception('Error creating payment intent: ${e.toString()}');
    }
  }

  int _getFinalAmount(double amount) {
    return (amount * 100).toInt();
  }
}

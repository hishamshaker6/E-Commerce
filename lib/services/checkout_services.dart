import 'package:onlinestore/models/address_model.dart';
import 'package:onlinestore/models/delivery_model.dart';
import 'package:onlinestore/models/payment_model.dart';
import 'package:onlinestore/services/auth_services.dart';
import 'package:onlinestore/services/firestore_services.dart';
import 'package:onlinestore/utilities/api_path.dart';

abstract class CheckoutServices {
  Future<void> setPaymentMethod(PaymentModel paymentModel);
  Future<void> deletePaymentMethod(PaymentModel paymentModel);
  Future<List<PaymentModel>> paymentModel([bool fetchPreferred = false]);
  Future<List<AddressModel>> addressModel(String userId);
  Future<List<DeliveryModel>> deliveryMethods();
  Future<void> saveAddress(String userId, AddressModel address);
}

class CheckoutServicesImpl implements CheckoutServices {
  final FirestoreServices firestoreServices = FirestoreServices.instance;
  final AuthServicesImpl authServices = AuthServicesImpl();

  @override
  Future<void> setPaymentMethod(PaymentModel paymentModel) async {
    final currentUser = authServices.currentUser;
    if (currentUser != null) {
      await firestoreServices.setData(
        path: ApiPath.addCard(currentUser.uid, paymentModel.id),
        data: paymentModel.toMap(),
      );
    } else {
      throw Exception('User not logged in');
    }
  }

  @override
  Future<void> deletePaymentMethod(PaymentModel paymentModel) async {
    final currentUser = authServices.currentUser;
    if (currentUser != null) {
      await firestoreServices.deleteData(
        path: ApiPath.addCard(currentUser.uid, paymentModel.id),
      );
    } else {
      throw Exception('User not logged in');
    }
  }

  @override
  Future<List<PaymentModel>> paymentModel([bool fetchPreferred = false]) async {
    final currentUser = authServices.currentUser;
    if (currentUser != null) {
      return await firestoreServices.getCollection(
        path: ApiPath.cards(currentUser.uid),
        builder: (data, documentId) => PaymentModel.fromMap(data),
        queryBuilder: fetchPreferred
            ? (query) => query.where('isPreferred', isEqualTo: true)
            : null,
      );
    } else {
      throw Exception('User not logged in');
    }
  }

  @override
  Future<List<DeliveryModel>> deliveryMethods() async {
    return await firestoreServices.getCollection(
      path: ApiPath.deliveryMethods(),
      builder: (data, documentId) => DeliveryModel.fromMap(data, documentId),
    );
  }

  @override
  Future<List<AddressModel>> addressModel(String userId) async {
    return await firestoreServices.getCollection(
      path: ApiPath.userShippingAddress(userId),
      builder: (data, documentId) => AddressModel.fromMap(data, documentId),
    );
  }

  @override
  Future<void> saveAddress(String userId, AddressModel address) async {
    await firestoreServices.setData(
      path: ApiPath.newAddress(userId, address.id),
      data: address.toMap(),
    );
  }
}

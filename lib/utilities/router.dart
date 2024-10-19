import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlinestore/controllers/checkout/checkout_cubit.dart';
import 'package:onlinestore/controllers/product_details/product_details_cubit.dart';
import 'package:onlinestore/models/args_model.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/pages/checkout/add_shipping_address_page.dart';
import 'package:onlinestore/views/pages/bottom_navbar.dart';
import 'package:onlinestore/views/pages/checkout/checkout_page.dart';
import 'package:onlinestore/views/pages/forget_password_page.dart';
import 'package:onlinestore/views/pages/login_page.dart';
import 'package:onlinestore/views/pages/checkout/payment_methods_page.dart';
import 'package:onlinestore/views/pages/product_details.dart';
import 'package:onlinestore/views/pages/profile_page.dart';
import 'package:onlinestore/views/pages/register_page.dart';
import 'package:onlinestore/views/pages/checkout/shipping_addresses_page.dart';
import 'package:onlinestore/views/pages/shop/accessories_page.dart';
import 'package:onlinestore/views/pages/shop/clothes_page.dart';
import 'package:onlinestore/views/pages/shop/new_clothes_page.dart';
import 'package:onlinestore/views/pages/shop/shoes_page.dart';
import 'package:onlinestore/views/pages/splash_page.dart';
import 'package:onlinestore/views/pages/start_page.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splashPageRoute:
      return MaterialPageRoute(
        builder: (_) => const SplashPage(),
        settings: settings,
      );
    case AppRoutes.startPageRoute:
      return MaterialPageRoute(
        builder: (_) => const StartPage(),
        settings: settings,
      );
    case AppRoutes.loginPageRoute:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
        settings: settings,
      );
    case AppRoutes.registerPageRoute:
      return MaterialPageRoute(
        builder: (_) => const RegisterPage(),
        settings: settings,
      );

    case AppRoutes.forgetPasswordPageRoute:
      return MaterialPageRoute(
        builder: (_) => const ForgetPasswordPage(),
        settings: settings,
      );
    case AppRoutes.newClothesPageRoute:
      return MaterialPageRoute(
        builder: (_) => const NewClothesPage(),
        settings: settings,
      );
    case AppRoutes.clothesPageRoute:
      return MaterialPageRoute(
        builder: (_) => const ClothesPage(),
        settings: settings,
      );
    case AppRoutes.shoesPageRoute:
      return MaterialPageRoute(
        builder: (_) => const ShoesPage(),
        settings: settings,
      );
    case AppRoutes.accessoriesPageRoute:
      return MaterialPageRoute(
        builder: (_) => const AccessoriesPage(),
        settings: settings,
      );

    case AppRoutes.bottomNavBarRoute:
      return MaterialPageRoute(
        builder: (_) => const BottomNavbar(),
        settings: settings,
      );
    case AppRoutes.profilePageRoute:
      return MaterialPageRoute(
        builder: (_) => const ProfilePage(),
        settings: settings,
      );
    case AppRoutes.productDetailsRoute:
      final arguments = settings.arguments as List<String>;
      final productId = arguments[0];
      final categoryType = arguments[1];

      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) {
            final cubit = ProductDetailsCubit();
            cubit.getProductDetails(productId, categoryType);
            return cubit;
          },
          child: const ProductDetails(),
        ),
        settings: settings,
      );

    case AppRoutes.checkoutPageRoute:
      final totalAmount = settings.arguments as double;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) {
            // Pass the totalAmount to CheckoutCubit
            return CheckoutCubit(totalAmount: totalAmount)
              ..getCheckoutData();
          },
          child: const CheckoutPage(),
        ),
        settings: settings,
      );


    case AppRoutes.shippingAddressesRoute:
      final checkoutCubit = settings.arguments as CheckoutCubit;
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: checkoutCubit,
          child: const ShippingAddressesPage(),
        ),
        settings: settings,
      );
    case AppRoutes.paymentMethodsRoute:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) {
            final cubit = CheckoutCubit(totalAmount: 0.0);
            cubit.fetchCards();
            return cubit;
          },
          child: const PaymentMethodsPage(),
        ),
        settings: settings,
      );
    case AppRoutes.addShippingAddressRoute:
      final args = settings.arguments as AddShippingAddressArgs;
      final checkoutCubit = args.checkoutCubit;
      final shippingAddress = args.shippingAddress;

      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: checkoutCubit,
          child: AddShippingAddressPage(
            shippingAddress: shippingAddress,
          ),
        ),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const BottomNavbar(),
        settings: settings,
      );
  }
}

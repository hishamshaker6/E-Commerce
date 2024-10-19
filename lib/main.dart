import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/utilities/constants.dart';
import 'package:onlinestore/utilities/router.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/utilities/theme_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSetup();
  runApp(const MyApp());
}

Future<void> initSetup() async {
  try {
    await Firebase.initializeApp();
    Stripe.publishableKey = AppConstants.publishableKey;
    await Stripe.instance.applySettings();
  } catch (e) {
    debugPrint('Firebase or Stripe initialization failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            onGenerateRoute: onGenerate,
            initialRoute: AppRoutes.splashPageRoute,
          );
        },
      ),
    );
  }
}

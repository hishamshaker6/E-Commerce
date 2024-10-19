import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      _navigateToNextPage();
    });
  }

  Future<void> _navigateToNextPage() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    await authCubit.authStatus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.bottomNavBarRoute);
        } else if (state is AuthInitial || state is AuthFailed) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.startPageRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppAssets.splashIcon,
                  height: 160.h,
                  width: 165.w,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Summer Sale',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

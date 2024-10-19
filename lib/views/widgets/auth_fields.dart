import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailField({Key? key, required this.emailController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.email),
        labelText: 'Email',
        labelStyle: TextStyle(
          color: AppColors.textColorRed,
          fontSize: 17.sp,
        ),
      ),
      validator: (val) => val!.isEmpty ? 'Please enter your email!' : null,
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final AuthCubit authCubit;
  final bool isPasswordVisible;

  const PasswordField({
    Key? key,
    required this.passwordController,
    required this.authCubit,
    required this.isPasswordVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => authCubit.togglePasswordVisibility(),
        ),
        labelText: 'Password',
        labelStyle: TextStyle(
          color: AppColors.textColorRed,
          fontSize: 17.sp,
        ),
      ),
      validator: (val) => val!.isEmpty ? 'Please enter your password!' : null,
    );
  }
}

class RePasswordField extends StatelessWidget {
  final TextEditingController rePasswordController;
  final TextEditingController passwordController;
  final AuthCubit authCubit;
  final bool isPasswordVisible;

  const RePasswordField({
    Key? key,
    required this.rePasswordController,
    required this.passwordController,
    required this.authCubit,
    required this.isPasswordVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: rePasswordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => authCubit.togglePasswordVisibility(),
        ),
        labelText: 'Re-enter Password',
        labelStyle: TextStyle(
          color: AppColors.textColorRed,
          fontSize: 17.sp,
        ),
      ),
      validator: (val) {
        if (val!.isEmpty) return 'Please re-enter your password!';
        if (val != passwordController.text) return 'Passwords do not match!';
        return null;
      },
    );
  }
}


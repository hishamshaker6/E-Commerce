import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/auth_fields.dart';
import 'package:onlinestore/views/widgets/main_button.dart';
import 'package:onlinestore/views/widgets/main_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 60.h),
                child: Form(
                  key: registerFormKey,
                  child: Column(
                    children: [
                      EmailField(emailController: _emailController),
                      SizedBox(height: 24.0.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          bool isPasswordVisible =
                              state is PasswordVisibilityChanged &&
                                  state.isVisible;
                          return PasswordField(
                            passwordController: _passwordController,
                            authCubit: authCubit,
                            isPasswordVisible: isPasswordVisible,
                          );
                        },
                      ),
                      SizedBox(height: 24.0.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          bool isPasswordVisible =
                              state is PasswordVisibilityChanged &&
                                  state.isVisible;
                          return RePasswordField(
                            rePasswordController: _rePasswordController,
                            passwordController: _passwordController,
                            authCubit: authCubit,
                            isPasswordVisible: isPasswordVisible,
                          );
                        },
                      ),
                      SizedBox(height: 40.0.h),
                      _buildSubmitButton(authCubit),
                      SizedBox(height: 16.0.h),
                      _buildLoginOption(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 30.h),
      height: 260.h,
      width: double.infinity,
      child: SvgPicture.asset(
        AppAssets.registerImage,
        height: 230.h,
        width: double.infinity,
      ),
    );
  }

  Widget _buildSubmitButton(AuthCubit authCubit) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          MainDialog(
            title: 'Registration Failed',
            content: state.error,
            context: context,
          ).showAlertDialog();
        } else if (state is AuthEmailVerificationSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Verification email has been sent to ${_emailController.text}.'
              ),
              backgroundColor: Colors.green,
            ),
          );
          _emailController.clear();
          _passwordController.clear();
          _rePasswordController.clear();
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator(
            strokeWidth: 3.w,
            color: AppColors.colorRed,
          );
        }
        return MainButton(
          text: 'Register',
          onTap: () {
            if (registerFormKey.currentState!.validate()) {
              authCubit.signUp(
                _emailController.text,
                _passwordController.text,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.loginPageRoute);
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: AppColors.textColorRed,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }
}

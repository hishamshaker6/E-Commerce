import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/assets.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/auth_fields.dart';
import 'package:onlinestore/views/widgets/main_button.dart';
import 'package:onlinestore/views/widgets/main_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EmailField(emailController: _emailController),
                      SizedBox(height: 24.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          bool isPasswordVisible = state is PasswordVisibilityChanged && state.isVisible;
                          return PasswordField(
                            passwordController: _passwordController,
                            authCubit: authCubit,
                            isPasswordVisible: isPasswordVisible,
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      _buildForgotPasswordButton(context),
                      SizedBox(height: 25.h),
                      _buildLoginButton(authCubit),
                      SizedBox(height: 16.h),
                      _buildRegisterRow(),

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
      padding: EdgeInsets.only(top: 35.h),
      height: 280.h,
      width: double.infinity,
      child: SvgPicture.asset(AppAssets.loginImage,),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.forgetPasswordPageRoute);
        },
        child: Text(
          'Forgot your password ?',
          style: TextStyle(color: AppColors.textColorRed, fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthCubit authCubit) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          _emailController.clear();
          _passwordController.clear();
          MainDialog(
            title: 'Login Failed',
            content: state.error,
            context: context,
          ).showAlertDialog();
        } else if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.bottomNavBarRoute);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator(strokeWidth: 3.w,color: AppColors.colorRed,
          );
        }
        return MainButton(
          text: 'Login',
          onTap: () {
            if (_formKey.currentState!.validate()) {
              authCubit.login(
                _emailController.text,
                _passwordController.text,
              );
            }
          },
        );
      },
    );
  }


  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.registerPageRoute);
          },
          child: Text(
            'Register',
            style: TextStyle(color: AppColors.textColorRed, fontSize: 15.sp),
          ),
        ),
      ],
    );
  }
}

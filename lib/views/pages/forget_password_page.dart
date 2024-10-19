import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/main_button.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _forgetPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _forgetPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final AuthCubit authCubit = context.read<AuthCubit>();

      try {
        await authCubit.resetPassword(_forgetPasswordController.text);
        _showSnackBar('Reset Password link sent to ${_forgetPasswordController.text}', Colors.green);
      } catch (error) {
        _showSnackBar('Failed to send reset link: $error', AppColors.textColorRed);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textColorWhite),
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 50.h),
              _buildInstructionText(),
              SizedBox(height: 20.h),
              _buildEmailField(),
              SizedBox(height: 20.h),
              MainButton(
                text: 'Send',
                onTap: _sendResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h,),
      child: Row(
        children: [
          IconButton(onPressed: ()=>Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back,size: 30.sp,color: AppColors.colorRed,)),
          SizedBox(width: 5.w,),
          Text(
            'Forget Password',
            style: TextStyle(
              fontSize: 30.0.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionText() {
    return Center(
      child: Text(
        'Please, enter your email address. You will receive a link to create a new password via email.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
      ),
    );
  }

  Widget _buildEmailField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _forgetPasswordController,
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter your email!';
          }
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
            return 'Please enter a valid email address!';
          }
          return null;
        },
      ),
    );
  }
}

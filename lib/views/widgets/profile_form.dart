import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/auth/auth_cubit.dart';
import 'package:onlinestore/controllers/profile/profile_cubit.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/utilities/routes.dart';
import 'package:onlinestore/views/widgets/main_button.dart';

class ProfileForm extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileForm({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: userData['email']);
    final usernameController = TextEditingController(text: userData['username']);
    final phoneController = TextEditingController(text: userData['phone']);
    String? imageBase64 = userData['imageBase64'];

    return Column(
      children: [
        SizedBox(
          height: 240.h,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 210.h,
                decoration: BoxDecoration(
                  color: AppColors.colorRed,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.r),
                    bottomLeft: Radius.circular(30.r),
                  ),
                ),
              ),
              Positioned(
                top: 105.h,
                left: 140.w,
                child: GestureDetector(
                  onTap: () => context.read<ProfileCubit>().pickImage(),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundImage: imageBase64 != null
                        ? MemoryImage(base64Decode(imageBase64))
                        : null,
                    child: imageBase64 == null
                        ? Icon(Icons.person, size: 50.sp)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Column(
            children: [
              BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileLoaded) {
                    usernameController.text = state.userData['username'];
                  }
                },
                child: Column(
                  children: [
                    Text(
                      usernameController.text,
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 60.h),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: AppColors.colorRed),
                      ),
                      onChanged: (value) {
                        context.read<ProfileCubit>().updateUserName(value);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppColors.colorRed),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: AppColors.colorRed),
                ),
              ),
              SizedBox(height: 30.h),
              MainButton(
                text: 'Save',
                onTap: () {
                  context.read<ProfileCubit>().saveUserData(
                    emailController.text,
                    usernameController.text,
                    phoneController.text,
                    imageBase64,
                  );
                },
              ),
              SizedBox(height: 5.h),
              MainButton(
                text: 'Logout',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),

            ],
          ),
        ),
      ],
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                context.read<AuthCubit>().logout();
                Navigator.of(context).pushReplacementNamed(
                    AppRoutes.loginPageRoute);
              },  ),
          ],
        );
      },
    );
  }
}



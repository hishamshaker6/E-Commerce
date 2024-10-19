import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlinestore/controllers/profile/profile_cubit.dart';
import 'package:onlinestore/services/profile_services.dart';
import 'package:onlinestore/utilities/colors.dart';
import 'package:onlinestore/views/widgets/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileServices())..loadUserData(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(child: CircularProgressIndicator(strokeWidth: 3.w, color: AppColors.colorRed));
              } else if (state is ProfileLoaded) {
                final userData = state.userData;
                return ProfileForm(userData: userData);
              } else if (state is ProfileError) {
                return Center(child: Text(state.error));
              } else {
                return const Center(child: Text("No data available"));
              }
            },
          ),
        ),
      ),
    );
  }
}

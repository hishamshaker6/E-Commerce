import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onlinestore/services/profile_services.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileServices _profileServices;
  final int maxSizeInBytes = 500 * 1024;

  ProfileCubit(this._profileServices) : super(ProfileInitial());

  void loadUserData() async {
    try {
      emit(ProfileLoading());
      final userData = await _profileServices.getUserData();
      emit(ProfileLoaded(userData));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  void saveUserData(String email, String username, String phone, String? imageBase64) async {
    try {
      emit(ProfileLoading());
      await _profileServices.saveUserData(email, username, phone, imageBase64);
      emit(ProfileSaved());
      loadUserData();
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  void updateUserName(String newUserName) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedUserData = Map<String, dynamic>.from(currentState.userData);
      updatedUserData['username'] = newUserName;

      emit(ProfileLoaded(updatedUserData));
    }
  }

  void pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File profileImage = File(pickedFile.path);
        int fileSize = await profileImage.length();
        if (fileSize > maxSizeInBytes) {
          emit(ProfileError('Image size must be less than 500 KB.'));
        } else {
          String imageBase64 = await _profileServices.convertImageToBase64(profileImage);

          if (state is ProfileLoaded) {
            final currentState = state as ProfileLoaded;
            final updatedUserData = Map<String, dynamic>.from(currentState.userData);
            updatedUserData['imageBase64'] = imageBase64;

            emit(ProfileLoaded(updatedUserData));
          } else {
            emit(ProfileImagePicked(imageBase64));
          }
        }
      }
    } catch (error) {
      emit(ProfileError('An error occurred while selecting the image.'));
    }
  }
}

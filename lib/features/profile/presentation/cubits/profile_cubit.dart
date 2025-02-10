import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/profile/domain/entities/profile_user.dart';
import 'package:socialx/features/profile/domain/repos/profile_repo.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_state.dart';
import 'package:socialx/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  //fetch user profile(useful  for a single profile)
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User Not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

//useful for loading many profiles in posts
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);

    return user;
  }

  //update userProfile

  Future<void> updateProfile(
      {required String uid,
      String? newBio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    emit(ProfileLoading());

    try {
      //fetch current user

      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));

        return;
      }

      //profilePic update
      String? imageDownloadUrl;
      if (imageWebBytes != null || imageMobilePath != null) {
        //for mobile
        if (imageMobilePath != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }

        //for web
        else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }
        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload Profile picture"));
        }
      }
      //update new profile

      final updatedProfile = currentUser.copyWith(
          newBio: newBio ?? currentUser.bio,
          newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl);

      //update in repo

      await profileRepo.updateProfile(updatedProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("updating profile error: $e.toString()"));
    }
  }

//toggle follow & unfollow
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
    } catch (e) {
      emit(ProfileError("Failed to toggle follow/unfollow: $e"));
    }
  }
}

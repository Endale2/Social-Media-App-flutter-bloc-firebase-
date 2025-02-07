import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/profile/domain/repos/profile_repo.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  //fetch user profile
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

  //update userProfile

  Future<void> updateProfile({required String uid, String? newBio}) async {
    emit(ProfileLoading());

    try {
      //fetch current user

      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));

        return;
      }

      //profilePic update

      //update new profile

      final updatedProfile =
          currentUser.copyWith(newBio: newBio ?? currentUser.bio);

      //update in repo

      await profileRepo.updateProfile(updatedProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("updating profile error: $e.toString()"));
    }
  }
}

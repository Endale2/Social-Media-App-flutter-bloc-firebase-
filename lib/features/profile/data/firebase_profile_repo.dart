import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialx/features/profile/domain/entities/profile_user.dart';
import 'package:socialx/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      //get user document from firestore

      final userDoc =
          await firebaseFirestore.collection("users").doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser(
              bio: userData["bio"] ?? '',
              profileImageUrl: userData["profileImageUrl"].toString(),
              email: userData["email"],
              name: userData["name"],
              uid: uid);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    //convert updated profile object to json to store in firestore

    try {
      await firebaseFirestore
          .collection("users")
          .doc(updatedProfile.uid)
          .update({
        "bio": updatedProfile.bio,
        "profileImageUrl": updatedProfile.profileImageUrl
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}

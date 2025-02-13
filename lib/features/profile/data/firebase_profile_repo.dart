import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialx/features/profile/domain/models/profile_user.dart';
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
          //fetch following and followers
          final followers = List<String>.from(userData["followers"] ?? []);
          final following = List<String>.from(userData["following"] ?? []);
          return ProfileUser(
              bio: userData["bio"] ?? '',
              profileImageUrl: userData["profileImageUrl"].toString(),
              email: userData["email"],
              name: userData["name"],
              uid: uid,
              followers: followers,
              following: following);
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

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection("users").doc(currentUid).get();
      final targetUserDoc =
          await firebaseFirestore.collection("users").doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData["following"] ?? []);

          //check if the current user already following the target

          if (currentFollowing.contains(targetUid)) {
            //unfollow
            await firebaseFirestore.collection("users").doc(currentUid).update({
              "following": FieldValue.arrayRemove([targetUid])
            });

            await firebaseFirestore.collection("users").doc(targetUid).update({
              "followers": FieldValue.arrayRemove([currentUid])
            });
          } else {
            //follow
            await firebaseFirestore.collection("users").doc(currentUid).update({
              "following": FieldValue.arrayUnion([targetUid])
            });

            await firebaseFirestore.collection("users").doc(targetUid).update({
              "followers": FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (e) {}
  }
}

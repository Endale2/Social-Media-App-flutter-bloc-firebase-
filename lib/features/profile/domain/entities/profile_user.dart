import 'package:socialx/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;
  ProfileUser(
      {required this.followers,
      required this.following,
      required this.bio,
      required this.profileImageUrl,
      required super.email,
      required super.name,
      required super.uid});

  //method to update  profile user

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      email: email,
      name: name,
      uid: uid,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
    );
  }

  //convert profile user to json

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "profileImageUrl": profileImageUrl,
      "followers": followers,
      "following": following
    };
  }

  //convert json to profile user object

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        bio: json["bio"] ?? '',
        profileImageUrl: json["profileImageUrl"] ?? "",
        email: json["email"],
        name: json["name"],
        uid: json["uid"],
        followers: List<String>.from(json["followers"] ?? []),
        following: List<String>.from(json["following"] ?? []));
  }
}

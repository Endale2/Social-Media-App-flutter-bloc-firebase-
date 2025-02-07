import 'package:socialx/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  ProfileUser(
      {required this.bio,
      required this.profileImageUrl,
      required super.email,
      required super.name,
      required super.uid});

  //method to update  profile user

  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
        bio: newBio ?? bio,
        profileImageUrl: newProfileImageUrl ?? profileImageUrl,
        email: email,
        name: name,
        uid: uid);
  }

  //convert profile user to json

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "profileImageUrl": profileImageUrl
    };
  }

  //convert json to profile user object

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        bio: json["bio"] ?? '',
        profileImageUrl: json["profileImageUrl"] ?? "",
        email: json["email"],
        name: json["name"],
        uid: json["uid"]);
  }
}

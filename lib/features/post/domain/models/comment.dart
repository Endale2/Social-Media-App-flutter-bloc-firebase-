import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;
  final String? profileImageUrl; // Optional field for the profile picture

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
    this.profileImageUrl,
  });

  // Convert the Comment to JSON.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "postId": postId,
      "userId": userId,
      "userName": userName,
      "text": text,
      "timestamp": Timestamp.fromDate(timestamp),
      "profileImageUrl": profileImageUrl, // will be null if not provided
    };
  }

  // Create a Comment object from JSON.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      postId: json["postId"],
      userId: json["userId"],
      userName: json["userName"],
      text: json["text"],
      timestamp: (json["timestamp"] as Timestamp).toDate(),
      profileImageUrl: json["profileImageUrl"],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialx/features/post/domain/entities/post.dart';
import 'package:socialx/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection("posts");
  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating posts: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("error deleting post : $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //get all posts with recent post at the top
      final postsSnapshot =
          await postsCollection.orderBy("timestamp", descending: true).get();
      //convert these posts from json to list of posts
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching all Posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      //posts for specific user
      final postsSnapshot =
          await postsCollection.where("userId", isEqualTo: userId).get();
      //convert posts from json to list of posts

      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error Fetching user posts $e");
    }
  }
}

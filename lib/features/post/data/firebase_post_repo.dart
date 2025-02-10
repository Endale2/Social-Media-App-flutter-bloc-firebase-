import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialx/features/post/domain/entities/comment.dart';
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

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //get the poost document from firestore

      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //check is the user is already liked this post

        final hasLiked = post.likes.contains(userId);

        if (hasLiked) {
          post.likes.remove(userId); //unlike the post
        } else {
          post.likes.add(userId); //like  the post
        }

        //update the post document with the new like list

        await postsCollection.doc(postId).update({"likes": post.likes});
      } else {
        throw Exception("Post Not found");
      }
    } catch (e) {
      throw Exception("Error toggling like: $e");
    }
  }

//add comment
  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //get post document

      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        //convert json to post

        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //add new comment

        post.comments.add(comment);
        //update comments

        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post Not Found");
      }
    } catch (e) {
      throw Exception("Error adding comments : $e");
    }
  }

// delete comment

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      //get post document

      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        //convert json to post

        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //remove  comment

        post.comments.remove((comment) => comment.id == commentId);
        //update comments

        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post Not Found");
      }
    } catch (e) {
      throw Exception("Error adding comments : $e");
    }
  }
}

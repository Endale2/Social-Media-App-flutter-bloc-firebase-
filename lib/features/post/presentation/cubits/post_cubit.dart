import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/post/domain/entities/comment.dart';
import 'package:socialx/features/post/domain/entities/post.dart';
import 'package:socialx/features/post/domain/repos/post_repo.dart';
import 'package:socialx/features/post/presentation/cubits/post_state.dart';
import 'package:socialx/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostInitial());

  //create new post

  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      //handle image upload for mobile

      if (imagePath != null) {
        emit(PostLoading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      //handle image upload for web
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }
      //give imageUrl to post

      final newPost = post.copyWith(imageUrl: imageUrl);

      //create post in backend

      postRepo.createPost(newPost);
      fetchAllPosts();
    } catch (e) {
      emit(PostError("failed to create post $e"));
    }
  }

//fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError("Failed to load posts"));
    }
  }
  //delete a post

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError("unable to delete the post: $e "));
    }
  }

//toggle like on post

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostError("Failed to toggle like: $e"));
    }
  }
//add comment

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError(" Failed to add comment : $e"));
    }
  }

//delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostError("Failed to delete comment: $e"));
    }
  }
}

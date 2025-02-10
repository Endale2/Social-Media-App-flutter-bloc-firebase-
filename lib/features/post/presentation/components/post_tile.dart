import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/presentation/components/my_text_field.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/post/domain/entities/comment.dart';
import 'package:socialx/features/post/domain/entities/post.dart';
import 'package:socialx/features/post/presentation/components/comment_tile.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';
import 'package:socialx/features/post/presentation/cubits/post_state.dart';
import 'package:socialx/features/profile/domain/entities/profile_user.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:socialx/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //post and profile cubits

  late final profileCubit = context.read<ProfileCubit>();
  late final postCubit = context.read<PostCubit>();

  bool isOwnPost = false;

  //current user

  AppUser? currentUser;

  //post user

  ProfileUser? postUser;
  //on the app start

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;

    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);

    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

//likes

  void toggleLikePost() {
    //current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    //update like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); //revert like
        } else {
          widget.post.likes
              .remove(currentUser!.uid); // revert unlike if error happened
        }
      });
    });
  }
  //show options for deleting the post

//COMMENTS

  final commentTextController = TextEditingController();
  //comment box

  void openCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Add New Comment",
          obscureText: false,
        ),
        actions: [
          //cancel  button

          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),

          //save button
          TextButton(
              onPressed: () {
                addComment();
                Navigator.of(context).pop();
              },
              child: Text("Save"))
        ],
      ),
    );
  }

  void addComment() {
    // create new comment

    final newComment = Comment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: commentTextController.text,
        timestamp: DateTime.now());

    //add comment by cubit

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

//show options for deleting
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post?"),
        actions: [
          //cancel button
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel")),

          //delete button
          TextButton(
              onPressed: () {
                widget.onDeletePressed!();
                Navigator.of(context).pop();
              },
              child: Text("delete"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          //post card header

          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(uid: widget.post.userId))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                          imageBuilder: (context, imageProvider) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              )),
                        )
                      : Icon(Icons.person),

                  const SizedBox(width: 20),
                  //profile name
                  Text(widget.post.userName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),

                  //delete button
                  if (isOwnPost)
                    GestureDetector(
                        onTap: showOptions,
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                ],
              ),
            ),
          ),
          //image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          //  like , comment and timestamp  buttons

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                //like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                            widget.post.likes.contains(currentUser!.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.likes.contains(currentUser!.uid)
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 5),
                      //like number
                      Text(widget.post.likes.length.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                ),

                //comment

                GestureDetector(
                    onTap: openCommentBox, child: Icon(Icons.comment)),
                const SizedBox(width: 5),
                //comment count
                Text(widget.post.comments.length.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary)),
                const Spacer(),
                //stamp
                Text(widget.post.timestamp.toString())
              ],
            ),
          ),

          //CAPTION

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                //username
                Text(widget.post.userName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                //text
                Text(widget.post.text)
              ],
            ),
          ),

          //COMMENTS

          BlocBuilder<PostCubit, PostState>(builder: (context, state) {
            //loaded

            if (state is PostLoaded) {
              //get individual post
              final post =
                  state.posts.firstWhere((post) => post.id == widget.post.id);

              if (post.comments.isNotEmpty) {
                int showCommentCount = post.comments.length;
                //comment section

                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: showCommentCount,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      return CommentTile(
                        comment: comment,
                      );
                    });
              }
            }
            // Loading

            if (state is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //Error

            else if (state is PostError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          })
        ],
      ),
    );
  }
}

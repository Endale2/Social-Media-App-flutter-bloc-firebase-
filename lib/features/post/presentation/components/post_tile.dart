import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/post/domain/entities/post.dart';
import 'package:socialx/features/post/presentation/components/comment_popup.dart';
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
  late final profileCubit = context.read<ProfileCubit>();
  late final postCubit = context.read<PostCubit>();
  AppUser? currentUser;
  ProfileUser? postUser;
  bool isOwnPost = false;

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

  // Updated like/unlike functionality with optimistic UI update.
  void toggleLikePost() {
    // Current like status.
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // Optimistically update UI.
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    // Update like on backend.
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      // If error occurs, revert to previous state.
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // Revert unlike.
        } else {
          widget.post.likes.remove(currentUser!.uid); // Revert like.
        }
      });
    });
  }

  // Updated comment popup: set backgroundColor transparent to avoid double-layer,
  // and ensure dismissal on tapping outside or pressing back.
  void openCommentPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // Allow dismissal by tapping outside.
      enableDrag: true, // Allow dragging to dismiss.
      backgroundColor:
          Colors.transparent, // Prevents a double layer background.
      builder: (context) => CommentPopup(post: widget.post),
    );
  }

  // Show options modal when three vertical dots are tapped.
  void showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.save),
            title: Text("Save"),
            onTap: () {
              Navigator.pop(context);
              // Add save functionality if needed.
            },
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text("Report"),
            onTap: () {
              Navigator.pop(context);
              // Add report functionality if needed.
            },
          ),
          if (isOwnPost)
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                confirmDelete();
              },
            ),
        ],
      ),
    );
  }

  // Confirmation dialog for delete.
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed?.call();
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Added margin and a slight rounding for the PostTile.
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8), // little rounding for PostTile
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Post header.
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(uid: widget.post.userId),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: postUser?.profileImageUrl != null
                        ? NetworkImage(postUser!.profileImageUrl)
                        : null,
                    child: postUser?.profileImageUrl == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Text(widget.post.userName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                // Three vertical dots for options.
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: showOptions,
                ),
              ],
            ),
          ),
          // New: Post text before the image, limited to 200 characters.
          if (widget.post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.post.text.length > 200
                    ? widget.post.text.substring(0, 200) + '...'
                    : widget.post.text,
              ),
            ),
          // Post image with less rounded corners.
          ClipRRect(
            borderRadius: BorderRadius.circular(4), // less rounding for image
            child: CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              height: 430,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Action buttons.
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Like button.
                IconButton(
                  icon: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : null,
                  ),
                  onPressed: toggleLikePost,
                ),
                // Like count with label.
                Text('${widget.post.likes.length} likes',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(width: 20),
                // Comment button.
                IconButton(
                  icon: Icon(Icons.comment,
                      color: Theme.of(context).colorScheme.inversePrimary),
                  onPressed: openCommentPopup,
                ),
                // Comment count with label.
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded) {
                      final post =
                          state.posts.firstWhere((p) => p.id == widget.post.id);
                      return GestureDetector(
                          onTap: openCommentPopup,
                          child: Text('${post.comments.length} comments',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)));
                    }
                    return Text("0 comments");
                  },
                ),
                Spacer(),
                // Timestamp.
                Text(
                  timeago.format(widget.post.timestamp),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

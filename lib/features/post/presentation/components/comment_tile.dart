import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/post/domain/entities/comment.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnComment = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnComment = (widget.comment.userId == currentUser!.uid);
  }

  // Show options for deleting the comment.
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment?"),
        actions: [
          // Cancel button.
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          // Delete button.
          TextButton(
            onPressed: () {
              context
                  .read<PostCubit>()
                  .deleteComment(widget.comment.postId, widget.comment.id);
              Navigator.of(context).pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImageUrl = widget.comment.profileImageUrl;
    final String initialLetter = widget.comment.userName.isNotEmpty
        ? widget.comment.userName.substring(0, 1).toUpperCase()
        : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          backgroundImage:
              (profileImageUrl != null && profileImageUrl.isNotEmpty)
                  ? NetworkImage(profileImageUrl)
                  : null,
          child: (profileImageUrl == null || profileImageUrl.isEmpty)
              ? Text(
                  initialLetter,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
        ),
        title: Text(
          widget.comment.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.comment.text),
        trailing: isOwnComment
            ? IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: showOptions,
              )
            : null,
      ),
    );
  }
}

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

  //show options for deleting
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Comment?"),
        actions: [
          //cancel button
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel")),

          //delete button
          TextButton(
              onPressed: () {
                context
                    .read<PostCubit>()
                    .deleteComment(widget.comment.postId, widget.comment.id);
                Navigator.of(context).pop();
              },
              child: Text("delete"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          //name
          Text(widget.comment.userName,
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),

          //comment text

          Text(widget.comment.text),

          //button to delete comment

          if (isOwnComment)
            GestureDetector(
                onTap: showOptions,
                child: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/post/domain/entities/comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;
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

          Text(widget.comment.text)

          //button to delete comment
        ],
      ),
    );
  }
}

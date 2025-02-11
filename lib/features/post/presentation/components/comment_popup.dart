import 'package:flutter/material.dart';
import 'package:socialx/features/post/domain/entities/comment.dart';
import 'package:socialx/features/post/domain/entities/post.dart';
import 'package:socialx/features/post/presentation/components/comment_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';
import 'package:socialx/features/auth/presentation/components/my_text_field.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/post/presentation/cubits/post_state.dart';

class CommentPopup extends StatefulWidget {
  final Post post;
  const CommentPopup({super.key, required this.post});

  @override
  State<CommentPopup> createState() => _CommentPopupState();
}

class _CommentPopupState extends State<CommentPopup> {
  final TextEditingController commentController = TextEditingController();
  late final PostCubit postCubit;
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>();
    currentUser = context.read<AuthCubit>().currentUser;
  }

  void addComment() {
    if (commentController.text.isNotEmpty) {
      final newComment = Comment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: commentController.text,
        timestamp: DateTime.now(),
      );
      postCubit.addComment(widget.post.id, newComment);
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded) {
                      final post =
                          state.posts.firstWhere((p) => p.id == widget.post.id);
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          return CommentTile(comment: post.comments[index]);
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: commentController,
                        hintText: "Add a comment...",
                        obscureText: false,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: addComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/post/domain/entities/post.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';
import 'package:socialx/features/profile/domain/entities/profile_user.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';

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

  //show options for deleting the post

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

          Padding(
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
                  IconButton(onPressed: showOptions, icon: Icon(Icons.delete)),
              ],
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
        ],
      ),
    );
  }
}

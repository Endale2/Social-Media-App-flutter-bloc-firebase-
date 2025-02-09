import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socialx/features/post/domain/entities/post.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //options for deleting the post

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.post.userName),
            IconButton(
                onPressed: widget.onDeletePressed, icon: Icon(Icons.delete))
          ],
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
    );
  }
}

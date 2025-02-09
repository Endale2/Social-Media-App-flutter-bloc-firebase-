import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/home/presentation/components/my_drawer.dart';
import 'package:socialx/features/post/presentation/components/post_tile.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';
import 'package:socialx/features/post/presentation/cubits/post_state.dart';
import 'package:socialx/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();

  //initial state

  @override
  void initState() {
    super.initState();
    //fetch all posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadPostPage())),
              icon: Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        //loading..

        if (state is PostLoading || state is PostUploading) {
          return Center(child: CircularProgressIndicator());
        }

        //loaded
        else if (state is PostLoaded) {
          final allPosts = state.posts;

          if (allPosts.isEmpty) {
            return Center(child: Text("No Posts Yet"));
          }
          return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                //get single post
                final post = allPosts[index];
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              });
        }
        //error

        else if (state is PostError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const SizedBox();
        }
      }),
      drawer: const MyDrawer(),
    );
  }
}

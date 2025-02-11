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
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
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
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadPostPage(),
              ),
            ),
            icon: const Icon(Icons.add_circle_outline, size: 28),
          ),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          Widget content;

          if (state is PostLoading || state is PostUploading) {
            // Show a custom rotating loading indicator with animation.
            content = const CoolLoadingIndicator();
          } else if (state is PostLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              content = const Center(
                child: Text(
                  "No Posts Yet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            } else {
              // Wrap the list in a RefreshIndicator for pull-to-refresh functionality.
              content = RefreshIndicator(
                onRefresh: () async {
                  fetchAllPosts();
                },
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: allPosts.length,
                  itemBuilder: (context, index) {
                    final post = allPosts[index];
                    // Each post animates in with a fade and slide effect.
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + index * 50),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: PostTile(
                        post: post,
                        onDeletePressed: () => deletePost(post.id),
                      ),
                    );
                  },
                ),
              );
            }
          } else if (state is PostError) {
            content = Center(
              child: Text(
                state.message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          } else {
            content = const SizedBox();
          }

          // Wrap the content in an AnimatedSwitcher for a smooth transition
          // when switching between different states.
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: content,
          );
        },
      ),
      drawer: const MyDrawer(),
    );
  }
}

/// A custom loading indicator that rotates an icon continuously.
class CoolLoadingIndicator extends StatefulWidget {
  const CoolLoadingIndicator({Key? key}) : super(key: key);

  @override
  _CoolLoadingIndicatorState createState() => _CoolLoadingIndicatorState();
}

class _CoolLoadingIndicatorState extends State<CoolLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // The controller rotates continuously.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle:
                _controller.value * 6.28318, // 2*PI radians for a full circle.
            child: child,
          );
        },
        child: Icon(
          Icons.sync,
          size: 50,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

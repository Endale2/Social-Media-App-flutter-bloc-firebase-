import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/models/app_user.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/post/presentation/components/post_tile.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';
import 'package:socialx/features/post/presentation/cubits/post_state.dart';
import 'package:socialx/features/profile/presentation/components/bio_box.dart';
import 'package:socialx/features/profile/presentation/components/follow_button.dart';
import 'package:socialx/features/profile/presentation/components/profile_stats.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_state.dart';
import 'package:socialx/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:socialx/features/profile/presentation/pages/follower_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late AppUser? currentUser = authCubit.currentUser;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
  }

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        if (isFollowing) {
          profileUser.followers.remove(currentUser!.uid);
        } else {
          profileUser.followers.add(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnProfile = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        final user = state.profileUser;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded, // iOS-style back arrow
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              user.name,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            centerTitle: true,
            actions: [
              if (isOwnProfile)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user)),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 72,
                    color: Colors.grey,
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Email
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Stats (Followers, Following, Posts)
                ProfileStats(
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  postCount: postCount,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowerPage(
                        followers: user.followers,
                        following: user.following,
                      ),
                    ),
                  ),
                ),

                // Follow/Unfollow Button
                if (!isOwnProfile)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid),
                    ),
                  ),

                // Bio Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bio",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                BioBox(text: user.bio),
                const SizedBox(height: 20),

                // Posts Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Posts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // User Posts
                BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  if (state is PostLoaded) {
                    final userPosts = state.posts
                        .where((post) => post.userId == widget.uid)
                        .toList();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          postCount = userPosts.length;
                        });
                      }
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: postCount,
                      itemBuilder: (context, index) {
                        final post = userPosts[index];
                        return PostTile(
                          post: post,
                          onDeletePressed: () =>
                              context.read<PostCubit>().deletePost(post.id),
                        );
                      },
                    );
                  } else if (state is PostLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                        child:
                            Text("No Posts", style: TextStyle(fontSize: 16)));
                  }
                }),
              ],
            ),
          ),
        );
      } else if (state is ProfileLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return const Center(child: Text("No Profile Found"));
      }
    });
  }
}

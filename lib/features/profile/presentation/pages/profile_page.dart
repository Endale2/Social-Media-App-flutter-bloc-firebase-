import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
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

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  //current User

  late AppUser? currentUser = authCubit.currentUser;

  //posts

  int postCount = 0;

  @override
  void initState() {
    super.initState();

    //load user

    profileCubit.fetchUserProfile(widget.uid);
  }

  //follo button

  void followButtonPressed() {
    final profileState = profileCubit.state;

    if (profileState is! ProfileLoaded) {
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);
    setState(() {
      if (isFollowing) {
        //unfollow
        profileUser.followers.remove(currentUser!.uid);
      } else {
        //follow
        profileUser.followers.add(currentUser!.uid);
      }
    });
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      //revert update if there is an error

      setState(() {
        if (isFollowing) {
          //unfollow
          profileUser.followers.remove(currentUser!.uid);
        } else {
          //follow
          profileUser.followers.add(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnProfile = (widget.uid == currentUser!.uid);
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      //data loaded
      if (state is ProfileLoaded) {
        //get user data
        final user = state.profileUser;
        return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                if (isOwnProfile)
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(user: user)));
                      },
                      icon: Icon(Icons.settings))
              ],
            ),
            body: ListView(
              children: [
                //email
                Center(
                  child: Text(user.email,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                const SizedBox(height: 25),
                //profile Picture

                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.person,
                      size: 72, color: Theme.of(context).colorScheme.primary),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const SizedBox(height: 25),
                //follow /unfollow count

                ProfileStats(
                    followerCount: user.followers.length,
                    followingCount: user.following.length,
                    postCount: postCount),
                //follow/unfollow button
                if (!isOwnProfile)
                  FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid)),

                //Bio box
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Bio",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                const SizedBox(height: 10),
                BioBox(text: user.bio),

                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  child: Text("Posts",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                ),

                const SizedBox(height: 10),
                //list of posts from this user

                BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  //loaded
                  if (state is PostLoaded) {
                    final userPosts = state.posts
                        .where((post) => post.userId == widget.uid)
                        .toList();
                    postCount = userPosts.length;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: postCount,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];

                          return PostTile(
                              post: post,
                              onDeletePressed: () => context
                                  .read<PostCubit>()
                                  .deletePost(post.id));
                        });
                  }

                  //loading
                  else if (state is PostLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text("No Posts"));
                  }

                  //error
                })
              ],
            ));
      }
      //data loading
      else if (state is ProfileLoading) {
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      } else {
        return Center(child: Text("No Profile Found "));
      }
    });
  }
}

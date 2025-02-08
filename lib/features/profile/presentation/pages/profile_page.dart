import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/profile/presentation/components/bio_box.dart';
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

  @override
  void initState() {
    super.initState();

    //load user

    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
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
            body: Column(
              children: [
                //email
                Text(user.email,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
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

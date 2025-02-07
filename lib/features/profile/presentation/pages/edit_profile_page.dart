import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/presentation/components/my_text_field.dart';
import 'package:socialx/features/profile/domain/entities/profile_user.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();
  //when update profile button pressed

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
          uid: widget.user.uid, newBio: bioTextController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      //profile loading

      if (state is ProfileLoading) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), Text("Uploading...")],
          ),
        );
      } else {
        return buildEditPage();
      }

      //profile error
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          foregroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            IconButton(onPressed: updateProfile, icon: Icon(Icons.upload))
          ],
        ),
        body: Column(
          children: [
            Text("Bio"),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: MyTextField(
                  controller: bioTextController,
                  hintText: "bio",
                  obscureText: false),
            )
          ],
        ));
  }
}

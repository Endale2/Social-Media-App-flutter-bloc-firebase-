import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
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
  //mobile image pick

  PlatformFile? imagePickedFile;

  //web picked file
  Uint8List? webImage;
  //pick image

  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //when update profile button pressed

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    //prepare images

    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          imageMobilePath: imageMobilePath,
          imageWebBytes: imageWebBytes);
    } else {
      Navigator.pop(context);
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

  Widget buildEditPage() {
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
            //profile picture
            Center(
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle),
                    clipBehavior: Clip.hardEdge,
                    child:
                        //picker for mobile
                        (!kIsWeb && imagePickedFile != null)
                            ? Image.file(File(imagePickedFile!.path!))
                            :
                            //for web
                            (kIsWeb && webImage != null)
                                ? Image.memory(webImage!)
                                :
                                //if there is no image picked

                                CachedNetworkImage(
                                    imageUrl: widget.user.profileImageUrl,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                        Icons.person,
                                        size: 72,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    imageBuilder: (context, imageProvider) =>
                                        Image(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                  ))),
            const SizedBox(height: 25),
            //pick image button
            Center(
                child: MaterialButton(
                    onPressed: pickImage,
                    color: Colors.blue,
                    child: Text("Pick image"))),
            //bio
            Text("Bio"),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: MyTextField(
                  controller: bioTextController,
                  hintText: "bio",
                  obscureText: false),
            ),
          ],
        ));
  }
}

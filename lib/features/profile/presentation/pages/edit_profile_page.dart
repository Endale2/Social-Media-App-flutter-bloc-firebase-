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
  PlatformFile? imagePickedFile;
  Uint8List? webImage;

  // Pick Image Function
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

  // Update Profile Function
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
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
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 10),
                  Text("Uploading...",
                      style: TextStyle(color: colorScheme.onBackground)),
                ],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildEditPage() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Theme.of(context).iconTheme.color, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: updateProfile,
            icon: Icon(
              Icons.check_rounded,
              color: Theme.of(context).iconTheme.color,
              weight: 20,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: colorScheme.primary, width: 2),
                        color: colorScheme.secondary,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: (!kIsWeb && imagePickedFile != null)
                          ? Image.file(File(imagePickedFile!.path!),
                              fit: BoxFit.cover)
                          : (kIsWeb && webImage != null)
                              ? Image.memory(webImage!, fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: widget.user.profileImageUrl,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: 72,
                                      color: colorScheme.primary),
                                  imageBuilder: (context, imageProvider) =>
                                      Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary,
                      ),
                      child: Icon(Icons.camera_alt,
                          color: colorScheme.onPrimary, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),

            // Bio Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Bio",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground),
              ),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: bioTextController,
              hintText: "Enter your bio",
              obscureText: false,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

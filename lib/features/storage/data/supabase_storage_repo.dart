import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:socialx/features/storage/domain/storage_repo.dart';

class SupabaseStorageRepo implements StorageRepo {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadBytes(fileBytes, fileName, "profile_images");
  }

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadBytes(fileBytes, fileName, "post_images");
  }

  /// Uploads a file from mobile storage
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);
      final fileBytes = await file.readAsBytes(); // Convert file to bytes
      return _uploadBytes(fileBytes, fileName, folder);
    } catch (e) {
      print("File upload failed: $e");
      return null;
    }
  }

  /// Uploads file bytes (used for web and mobile)
  Future<String?> _uploadBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      // Ensure a unique filename
      String uniqueFileName =
          "${fileName}_${DateTime.now().millisecondsSinceEpoch}";
      final filePath = "$folder/$uniqueFileName";

      // Upload file to the correct folder
      await supabase.storage
          .from("profile_images")
          .uploadBinary(filePath, fileBytes);

      // Get the public URL
      return supabase.storage.from("profile_images").getPublicUrl(filePath);
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }
}

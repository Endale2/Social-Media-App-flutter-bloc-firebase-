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

  // Upload file from mobile
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);
      final fileBytes = await file.readAsBytes();
      return _uploadBytes(fileBytes, fileName, folder);
    } catch (e) {
      print("File upload failed: $e");
      return null;
    }
  }

  // Upload file from web
  Future<String?> _uploadBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      final filePath = "$folder/$fileName";
      await supabase.storage
          .from('profile_images')
          .uploadBinary(filePath, fileBytes);
      return supabase.storage.from('profile_images').getPublicUrl(filePath);
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }
}

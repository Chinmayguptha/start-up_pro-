import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = Uuid();

  // Upload image to Firebase Storage
  Future<String> uploadImage(Uint8List imageBytes, String folder) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final Reference ref = _storage.ref().child('$folder/$fileName');
      
      final UploadTask uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Get image URL from Firebase Storage
  Future<String> getImageUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      print('Error getting image URL: $e');
      rethrow;
    }
  }

  // Delete image from Firebase Storage
  Future<void> deleteImage(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }
} 
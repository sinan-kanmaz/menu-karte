import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

class StorageService {
  final storage = FirebaseStorage.instance.ref();

  Future<String?> addCategoryImage(String path) async {
    DateTime now = DateTime.now();

    final imageRef = storage
        .child('categories')
        .child(now.microsecondsSinceEpoch.toString());

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );

    if (kIsWeb) {
      await imageRef.putData(await XFile(path).readAsBytes(), metadata);
    } else {
      await imageRef.putFile(io.File(path), metadata);
    }

    return await imageRef.getDownloadURL();
  }

  Future<String?> uploadMenuImage(String? path) async {
    DateTime now = DateTime.now();

    final imageRef = storage
        .child('menu-images')
        .child(now.microsecondsSinceEpoch.toString());

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path!},
    );

    if (kIsWeb) {
      await imageRef.putData(await XFile(path).readAsBytes(), metadata);
    } else {
      await imageRef.putFile(io.File(path), metadata);
    }

    return await imageRef.getDownloadURL();
  }

  Future<String?> uploadProfilePicture(String uid, String path) async {
    final imageRef = storage.child('avatars').child(uid);

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );

    if (kIsWeb) {
      await imageRef.putData(await XFile(path).readAsBytes(), metadata);
    } else {
      await imageRef.putFile(io.File(path), metadata);
    }

    return await imageRef.getDownloadURL();
  }

  Future<void> removeMenuImage(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }
}

@riverpod
StorageService storageService(ref) {
  return StorageService();
}

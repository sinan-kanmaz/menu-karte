import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/services/auth_service.dart';
import 'package:qrmenu/core/services/firestore_service.dart';
import 'package:qrmenu/core/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Ref _ref;
  AuthRepository(this._ref);

  void signOut() {
    _ref.read(authServiceProvider).signOut();
  }

  void updateLanguage(String language) {
    _ref.read(authServiceProvider).updateLanguage(language);
  }

  Future<void> signIn(String email, String password) async {
    return await _ref.read(authServiceProvider).signIn(email, password);
  }

  Future<void> resetPassword(String email) {
    return _ref.read(authServiceProvider).resetPassword(email);
  }

  Future<void> updateProfile(
      String uid, String name, String phoneNumber, String? imagePath) async {
    String? imageUrl;
    if (imagePath != null) {
      imageUrl = await _ref
          .read(storageServiceProvider)
          .uploadProfilePicture(uid, imagePath);

      if (imageUrl != null) {
        await _ref.read(authServiceProvider).updateProfilePhoto(imageUrl);
      }
    }

    await _ref.read(authServiceProvider).updateUserName(name);
    await _ref
        .read(firestoreServiceProvider)
        .updateProfile(uid, name, phoneNumber, imageUrl);
  }

  Future<void> updatePassword(String newPassword) async {
    return _ref.read(authServiceProvider).updatePassword(newPassword);
  }
}

@riverpod
AuthRepository authRepository(ref) {
  return AuthRepository(ref);
}

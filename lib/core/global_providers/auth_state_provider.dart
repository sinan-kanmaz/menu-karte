import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  AuthState() {
    listenUserChanges();
  }
  @override
  User? build() {
    state = null;
    return state;
  }

  listenUserChanges() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      state = event;
    });
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await ref.read(authRepositoryProvider).signIn(email, password);
      if (context.mounted) toast(context.localizations!.login_successFully);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      toast("ERROR: ${e.message}", bgColor: Colors.red);
    }
  }

  void signOut() {
    ref.read(authRepositoryProvider).signOut();
  }

  void updateLanguage(String language) {
    ref.read(authRepositoryProvider).updateLanguage(language);
  }

  void saveFcmToken(String? role) {
    if (role != null) {
      // ref.read(realtimeDbRepositoryProvider).saveFcmToken(state!.uid, role);
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await ref.read(authRepositoryProvider).resetPassword(email);
      if (context.mounted) {
        toast(context.localizations!.resetPasswordLinkHasSentYourMail);
        finish(context);
      }
    } on FirebaseException catch (e) {
      toast(e.message);
    }
  }

  void updateProfile(String name, String phoneNumber, String? imagePath) async {
    try {
      await ref
          .read(authRepositoryProvider)
          .updateProfile(state!.uid, name, phoneNumber, imagePath);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> updatePassword(String newPassword, BuildContext context) async {
    try {
      await ref.read(authRepositoryProvider).updatePassword(newPassword);
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text(context.localizations!.error),
            content: Text(
              e.message.toString(),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(context.localizations!.ok),
              )
            ],
          ),
        );
      }
      debugPrint(e.toString());
      return false;
    }
  }
}

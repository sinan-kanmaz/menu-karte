import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'menu_list_provider.g.dart';

@riverpod
Future<List<Menu>> menuList(Ref ref, String uid, String? category) async {
  return ref
      .read(firestoreRepositoryProvider)
      .getMenusByCategory(uid, category);
}

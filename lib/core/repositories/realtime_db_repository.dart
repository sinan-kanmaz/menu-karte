import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/services/firestore_service.dart';
import 'package:qrmenu/core/services/realtime_db_service.dart';
import 'package:qrmenu/core/services/storage_service.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'realtime_db_repository.g.dart';

class RealtimeDbRepository {
  final Ref _ref;
  RealtimeDbRepository(this._ref);

  Future<void> saveNewCategory(MenuCategory category) async {
    String? url;
    if (category.categoryImage != null) {
      url = await _ref
          .read(storageServiceProvider)
          .addCategoryImage(category.categoryImage!);

      if (url != null) {
        category.categoryImage = url;
      }
    }

    await _ref.read(firestoreServiceProvider).saveNewCategory(category);
  }

  Future<void> updateCategory(MenuCategory category) async {
    if (category.categoryImage != null) {
      if (!category.categoryImage!.startsWith("http")) {
        String? url;

        url = await _ref
            .read(storageServiceProvider)
            .addCategoryImage(category.categoryImage!);

        if (url != null) {
          category.categoryImage = url;
        }
      }
    }
    await _ref.read(firestoreServiceProvider).updateCategory(category);
  }

  Future<List<MenuCategory>> getCategories(String uid) {
    return _ref.read(realtimeDbServiceProvider).getCategories(uid);
  }
}

@riverpod
RealtimeDbRepository realtimeDbRepository(ref) {
  return RealtimeDbRepository(ref);
}

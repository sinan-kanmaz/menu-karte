import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:qrmenu/core/repositories/realtime_db_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'categories_provider.g.dart';

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  late List<MenuCategory> _categories;
  @override
  List<MenuCategory> build() {
    _categories = [];
    getCategories();
    return [];
  }

  Future<void> getCategories() async {
    final uid = ref.read(authStateProvider)!.uid;
    _categories =
        await ref.read(firestoreRepositoryProvider).getCategories(uid);
    state = _categories;
  }

  Future<bool> saveNewCategory(MenuCategory category) async {
    try {
      category.restaurantId = ref.read(authStateProvider)?.uid;
      await ref.read(realtimeDbRepositoryProvider).saveNewCategory(category);
      state = [...state, category];
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(MenuCategory category) async {
    try {
      category.restaurantId = ref.read(authStateProvider)?.uid;
      await ref.read(realtimeDbRepositoryProvider).updateCategory(category);
      getCategories();
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  List<MenuCategory> getCategoryListByTab(String? tab) {
    if (tab == null) {
      return _categories;
    } else {
      List<MenuCategory> categories = [];
      // if (ref.read(selectedCategoryProvider) == null) {
      //   for (MenuCategory category in _categories) {
      //     if (category.tab == tab) {
      //       categories.add(category);
      //     }
      //   }
      // } else {
      //   for (MenuCategory category in _categories) {
      //     if (category.tab == tab) {
      //       if (ref.read(selectedCategoryProvider)?.translateValues?.name ==
      //           category.translateValues?.name) {
      //         categories.add(category);
      //       }
      //     }
      //   }
      // }

      for (MenuCategory category in _categories) {
        if (category.tab == tab) {
          categories.add(category);
        }
      }

      return categories;
    }
  }

  MenuCategory? getCategoryById(String? id) {
    MenuCategory? selectedCategory;
    for (MenuCategory category in _categories) {
      if (category.id == id) {
        selectedCategory = category;
      }
    }

    return selectedCategory;
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_menus_provider.g.dart';

@Riverpod(keepAlive: true)
class RestaurantMenus extends _$RestaurantMenus {
  late List<Menu> menus;

  @override
  Map<String, List<Menu>> build() {
    menus = [];
    getMenus();
    return {};
  }

  getMenus() async {
    print('GET MENUS');
    try {
      Map<String, List<Menu>> menuByCategory = {};
      final uid = ref.read(authStateProvider)!.uid;

      menus = await ref.read(firestoreRepositoryProvider).getMenus(uid);

      List<MenuCategory> categories = ref.read(categoriesProvider);

      for (MenuCategory category in categories) {
        List<Menu> categoryMenus = [];
        for (Menu menu in menus) {
          if (menu.category == category.translateValues?.name) {
            categoryMenus.add(menu);
          }
        }
        menuByCategory[category.translateValues!.name.toString()] =
            categoryMenus;
      }
      state = menuByCategory;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  // Map<String, List<Menu>> selectCategory(String? selectedTab) {
  //   Map<String, List<Menu>> menuByCategory = {};

  //   List<MenuCategory> categories = ref.read(categoriesProvider);
  //   MenuCategory? selectedCategory = ref.read(selectedCategoryProvider);

  //   if (selectedTab == null) {
  //     if (selectedCategory == null) {
  //       for (MenuCategory category in categories) {
  //         List<Menu> categoryMenus = [];
  //         for (Menu menu in menus) {
  //           if (menu.category == category.name) {
  //             categoryMenus.add(menu);
  //           }
  //         }
  //         menuByCategory[category.name.toString()] = categoryMenus;
  //       }
  //     } else {
  //       List<Menu> categoryMenus = [];
  //       for (Menu menu in menus) {
  //         if (menu.category == selectedCategory.name) {
  //           categoryMenus.add(menu);
  //         }
  //       }
  //       menuByCategory[selectedCategory.name.toString()] = categoryMenus;
  //     }

  //     state = menuByCategory;
  //     return state;
  //   } else {
  //     if (selectedCategory == null) {
  //       for (MenuCategory category in categories) {
  //         List<Menu> categoryMenus = [];
  //         for (Menu menu in menus) {
  //           if (menu.category == category.name) {
  //             if (menu.tab == selectedTab) {
  //               categoryMenus.add(menu);
  //             }
  //           }
  //         }
  //         menuByCategory[category.name.toString()] = categoryMenus;
  //       }
  //     } else {
  //       List<Menu> categoryMenus = [];
  //       for (Menu menu in menus) {
  //         if (menu.category == selectedCategory.name) {
  //           if (menu.tab == selectedTab) {
  //             categoryMenus.add(menu);
  //           }
  //         }
  //       }
  //       menuByCategory[selectedCategory.name.toString()] = categoryMenus;
  //     }

  //     return menuByCategory;
  //     // return state;
  //   }
  // }

  Future<void> saveNewMenu(Menu menu) async {
    try {
      await ref.read(firestoreRepositoryProvider).saveNewMenu(menu);

      getMenus();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> delete(String id) async {
    try {
      await ref.read(firestoreRepositoryProvider).deleteMenu(id);
      getMenus();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateMenu(Menu menu) async {
    try {
      await ref.read(firestoreRepositoryProvider).updateMenu(menu);
      getMenus();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<MenuCategory?> getCategoryById(String uid, String? category) async {
    try {
      return ref
          .read(firestoreRepositoryProvider)
          .getCategoryById(uid, category);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> removeMenuImage(
      String menuId, String menuImage, List<String> imageUrls) async {
    await ref
        .read(firestoreRepositoryProvider)
        .removeMenuImage(menuId, menuImage, imageUrls);
  }
}

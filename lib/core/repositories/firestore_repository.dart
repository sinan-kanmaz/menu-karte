import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/services/firestore_service.dart';
import 'package:qrmenu/core/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_repository.g.dart';

class FirestoreRepository {
  final Ref _ref;
  FirestoreRepository(this._ref);

  Future<void> saveNewMenu(Menu menu) async {
    List<String> urls = [];
    for (String? path in menu.menuImage!) {
      String? url =
          await _ref.read(storageServiceProvider).uploadMenuImage(path);

      if (url != null) {
        urls.add(url);
      }
    }
    menu.menuImage = urls;
    return await _ref.read(firestoreServiceProvider).saveNewMenu(menu);
  }

  Future<void> updateMenu(Menu menu) async {
    List<String> urls = [];

    for (String? path in menu.menuImage!) {
      if (!path!.startsWith('https')) {
        String? url =
            await _ref.read(storageServiceProvider).uploadMenuImage(path);

        if (url != null) {
          urls.add(url);
        }
      } else {
        urls.add(path);
      }
    }
    menu.menuImage = urls;

    return _ref.read(firestoreServiceProvider).updateMenu(menu);
  }

  Future<List<Menu>> getMenus(String uid) async {
    return _ref.read(firestoreServiceProvider).getMenus(uid);
  }

  Future<void> deleteMenu(String id) {
    return _ref.read(firestoreServiceProvider).deleteMenu(id);
  }

  Future<Restaurant?> getRestaurant(String restaurantId) async {
    return _ref.read(firestoreServiceProvider).getRestaurant(restaurantId);
  }

  Future<Restaurant?> getRestaurantByPath(String path) async {
    return _ref.read(firestoreServiceProvider).getRestaurantByPath(path);
  }

  Future<void> saveNewTab(String uid, List<MenuTab> tabs) async {
    return _ref.read(firestoreServiceProvider).saveNewTab(uid, tabs);
  }

  Future<List<Menu>> getMenusByCategory(String uid, String? category) async {
    return _ref
        .read(firestoreServiceProvider)
        .getMenusByCategory(uid, category);
  }

  Future<List<MenuCategory>> getCategories(String uid) {
    return _ref.read(firestoreServiceProvider).getCategories(uid);
  }

  Future<void> setMenuStyle(
      String uid, int? selectedIndex, int? selectedRestaurantStyle) async {
    return _ref
        .read(firestoreServiceProvider)
        .setMenuStyle(uid, selectedIndex, selectedRestaurantStyle);
  }

  Future<MenuCategory?> getCategoryById(String? uid, String? category) async {
    return _ref.read(firestoreServiceProvider).getCategoryById(uid, category);
  }

  Future<void> deleteCategory(MenuCategory category) {
    return _ref.read(firestoreServiceProvider).deleteCategory(category);
  }

  Future<void> removeMenuImage(
      String menuId, String menuImage, List<String> imageUrls) async {
    await _ref.read(storageServiceProvider).removeMenuImage(menuImage);
    await _ref
        .read(firestoreServiceProvider)
        .updateMenuImage(menuId, imageUrls);
  }
}

@riverpod
FirestoreRepository firestoreRepository(ref) {
  return FirestoreRepository(ref);
}

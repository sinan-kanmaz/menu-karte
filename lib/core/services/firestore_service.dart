import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<void> saveNewMenu(Menu menu) async {
    DocumentReference ref = await db
        .collection('menus')
        .withConverter<Menu>(
          fromFirestore: (product, _) => Menu.fromJson(product.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .add(menu);

    await db.collection("menus").doc(ref.id).update({
      "id": ref.id,
      "translateValues": {
        "name": menu.translateValues?.name,
        "description": menu.translateValues?.description,
      }
    });
  }

  Future<List<Menu>> getMenus(String uid) async {
    List<Menu> menus = [];
    QuerySnapshot<Menu> query = await db
        .collection("menus")
        .where("restaurantId", isEqualTo: uid)
        .withConverter<Menu>(
          fromFirestore: (restaurant, _) => Menu.fromJson(restaurant.data()!),
          toFirestore: (restaurant, _) => restaurant.toJson(),
        )
        .get();

    for (final menu in query.docs) {
      menus.add(menu.data());
    }
    return menus;
  }

  Future<void> deleteMenu(String id) async {
    await db.collection("menus").doc(id).delete();
  }

  Future<void> updateMenu(Menu menu) async {
    await db.collection("menus").doc(menu.id).update(menu.toJson());
  }

  Future<Restaurant?> getRestaurant(String restaurantId) async {
    DocumentSnapshot<Restaurant> doc = await db
        .collection("users")
        .doc(restaurantId)
        .withConverter<Restaurant>(
          fromFirestore: (restaurant, _) =>
              Restaurant.fromJson(restaurant.data()!),
          toFirestore: (restaurant, _) => restaurant.toJson(),
        )
        .get();
    return doc.data();
  }

  Future<Restaurant?> getRestaurantByPath(String path) async {
    QuerySnapshot<Restaurant> doc = await db
        .collection("users")
        .where("path", isEqualTo: path)
        .withConverter<Restaurant>(
          fromFirestore: (restaurant, _) =>
              Restaurant.fromJson(restaurant.data()!),
          toFirestore: (restaurant, _) => restaurant.toJson(),
        )
        .get();

    if (doc.docs.isEmpty) {
      return null;
    } else {
      return doc.docs.first.data();
    }
  }

  Future<void> updateProfile(
      String uid, String name, String phoneNumber, String? imageUrl) async {
    await db.collection('users').doc(uid).update({
      "name": name,
      "contactNumber": phoneNumber,
      // "path": createPath(name),
      if (imageUrl != null) "restaurantLogo": imageUrl,
    });
  }

  Future<void> saveNewTab(String uid, List<MenuTab> tabs) async {
    List<Map> tabsData = [];
    for (MenuTab tab in tabs) {
      tabsData.add(tab.toJson());
    }
    await db.collection("users").doc(uid).update({"menuTabs": tabsData});
  }

  Future<List<Menu>> getMenusByCategory(String uid, String? category) async {
    List<Menu> menus = [];
    QuerySnapshot<Menu> query = await db
        .collection("menus")
        .where("restaurantId", isEqualTo: uid)
        .where('category', isEqualTo: category)
        .orderBy("order")
        .withConverter<Menu>(
          fromFirestore: (restaurant, _) => Menu.fromJson(restaurant.data()!),
          toFirestore: (restaurant, _) => restaurant.toJson(),
        )
        .get();

    for (final menu in query.docs) {
      menus.add(menu.data());
    }
    return menus;
  }

  Future<void> saveNewCategory(MenuCategory category) async {
    DocumentReference snap = await db
        .collection("users")
        .doc(category.restaurantId)
        .collection("categories")
        .add(category.toJson());

    await db
        .collection("users")
        .doc(category.restaurantId)
        .collection("categories")
        .doc(snap.id)
        .update({
      "translateValues": {
        "name": category.translateValues?.name,
        "description": category.translateValues?.description,
      }
    });
  }

  Future<void> updateCategory(MenuCategory category) async {
    await db
        .collection("users")
        .doc(category.restaurantId)
        .collection("categories")
        .doc(category.id)
        .update(category.toJson());
  }

  Future<List<MenuCategory>> getCategories(String uid) async {
    List<MenuCategory> categories = [];

    QuerySnapshot<MenuCategory> snap = await db
        .collection("users")
        .doc(uid)
        .collection("categories")
        .orderBy("order")
        .withConverter<MenuCategory>(
          fromFirestore: (category, _) =>
              MenuCategory.fromJson(category.data()!),
          toFirestore: (category, _) => category.toJson(),
        )
        .get();

    for (final category in snap.docs) {
      MenuCategory ctg = category.data();
      ctg.id = category.id;
      categories.add(ctg);
    }

    return categories;
  }

  Future<void> setMenuStyle(
      String uid, int? selectedIndex, int? selectedRestaurantStyle) async {
    await db.collection('users').doc(uid).update({
      "menuStyle": selectedIndex,
      "restaurantStyle": selectedRestaurantStyle
    });
  }

  Future<MenuCategory?> getCategoryById(String? uid, String? category) async {
    DocumentSnapshot<MenuCategory> snap = await db
        .collection("users")
        .doc(uid)
        .collection("categories")
        .doc(category)
        .withConverter<MenuCategory>(
          fromFirestore: (category, _) =>
              MenuCategory.fromJson(category.data()!),
          toFirestore: (category, _) => category.toJson(),
        )
        .get();

    return snap.data();
  }

  Future<void> deleteCategory(MenuCategory category) async {
    await db
        .collection("users")
        .doc(category.restaurantId)
        .collection("categories")
        .doc(category.id)
        .delete();
  }

  void updateMainTab() async {
    List<MenuCategory> categories = [];

    QuerySnapshot<MenuCategory> snap = await db
        .collection("users")
        .doc("4rUyLHDuGNboLfTjVe0h0cwnk6C2")
        .collection("categories")
        .where("tab", isEqualTo: "In Haus")
        .withConverter<MenuCategory>(
          fromFirestore: (category, _) =>
              MenuCategory.fromJson(category.data()!),
          toFirestore: (category, _) => category.toJson(),
        )
        .get();

    for (final category in snap.docs) {
      MenuCategory ctg = category.data();
      ctg.id = category.id;
      categories.add(ctg);
      await db
          .collection('users')
          .doc("4rUyLHDuGNboLfTjVe0h0cwnk6C2")
          .collection("categories")
          .doc(category.id)
          .update({"tab": "Main Menu"});
    }
  }

  Future<void> updateMenuImage(String menuId, List<String> imageUrls) async {
    await db.collection("menus").doc(menuId).update({"menuImage": imageUrls});
  }
}

@riverpod
FirestoreService firestoreService(ref) {
  return FirestoreService();
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_state_provider.g.dart';

@Riverpod(keepAlive: true)
class UserState extends _$UserState {
  UserState() {
    listenUserChanges();
  }
  @override
  Restaurant? build() {
    state = null;
    return state;
  }

  listenUserChanges() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        getRestauarnt(event.uid);
      } else {
        state = null;
      }
    });
  }

  Future<void> getRestauarnt(String uid) async {
    try {
      state = await ref.read(firestoreRepositoryProvider).getRestaurant(uid);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addNewTab(MenuTab tab) async {
    try {
      List<MenuTab> tabs = [];
      if (state?.menuTabs != null) {
        tabs = state!.menuTabs!;
      }
      tabs.add(tab);
      await ref.read(firestoreRepositoryProvider).saveNewTab(state!.uid, tabs);

      Restaurant restaurnt = state!;
      restaurnt.menuTabs = tabs;
      state = null;
      state = restaurnt;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  void removeMenuTab(String menuTab) async {
    try {
      // List<String> menuTabs = state!.menuTabs!;
      // menuTabs.remove(menuTab);

      // await ref
      //     .read(firestoreRepositoryProvider)
      //     .saveNewTab(state!.uid, menuTabs);
      // Restaurant restaurnt = state!;
      // restaurnt.menuTabs = menuTabs;
      // state = null;
      // state = restaurnt;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setMenuStyle(
      int? selectedIndex, int? selectedRestaurantStyle) async {
    try {
      await ref
          .read(firestoreRepositoryProvider)
          .setMenuStyle(state!.uid, selectedIndex, selectedRestaurantStyle);
      Restaurant restaurnt = state!;
      restaurnt.menuStyle = selectedIndex;
      restaurnt.restaurantStyle = selectedRestaurantStyle;
      state = null;
      state = restaurnt;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }
}

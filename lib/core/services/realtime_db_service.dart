import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'realtime_db_service.g.dart';

class RealtimeDbService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  Future<void> saveNewCategory(MenuCategory category) async {
    DatabaseReference dbref =
        _ref.child('categories/${category.restaurantId}').push();
    await dbref.set(category.toJson());
  }

  Future<List<MenuCategory>> getCategories(String uid) async {
    List<MenuCategory> categories = [];
    DataSnapshot data = await _ref.child('categories/$uid').get();

    if (data.value != null) {
      Map<String, dynamic> values = json.decode(json.encode(data.value));
      for (final value in values.values.toList()) {
        categories.add(MenuCategory.fromJson(value));
      }
    }
    return categories;
  }
}

@riverpod
RealtimeDbService realtimeDbService(ref) {
  return RealtimeDbService();
}

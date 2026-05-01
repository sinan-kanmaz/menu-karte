import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/repositories/realtime_db_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restaurant_categories_provider.g.dart';

@riverpod
Future<List<MenuCategory>?> restaurantCategories(
    Ref ref, String restaurantId) async {
  return ref.read(realtimeDbRepositoryProvider).getCategories(restaurantId);
}

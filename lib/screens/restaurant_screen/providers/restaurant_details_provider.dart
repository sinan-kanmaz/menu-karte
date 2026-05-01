import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/services/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restaurant_details_provider.g.dart';

@riverpod
Future<Restaurant?> restaurantDetails(Ref ref, String restaurantId) async {
  return ref.read(firestoreServiceProvider).getRestaurant(restaurantId);
}

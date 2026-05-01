import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restaurant_provider.g.dart';

@riverpod
Future<Restaurant?> restaurant(Ref ref, String uid) async {
  return ref.read(firestoreRepositoryProvider).getRestaurant(uid);
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'settings_box.g.dart';

@riverpod
Box settingsBox(ref) {
  return Hive.box('settings');
}

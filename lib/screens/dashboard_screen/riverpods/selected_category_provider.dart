import 'package:qrmenu/core/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_category_provider.g.dart';

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  MenuCategory? build() {
    return null;
  }

  void setCategory(MenuCategory? value) {
    state = value;
  }
}

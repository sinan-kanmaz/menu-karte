import 'category.dart';
import 'menu/menu.dart';

class MenuCategoryModel {
  int? categoryId;
  MenuCategory? category;
  List<QuantityMenuModel>? menu;

  MenuCategoryModel({this.categoryId, this.menu, this.category});
}

class QuantityMenuModel {
  Menu? menu;
  int? quantity;

  QuantityMenuModel({this.quantity, this.menu});
}

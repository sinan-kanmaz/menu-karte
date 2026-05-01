import 'amount.dart';
import 'translate_values.dart';
import 'translated_values.dart';

class Menu {
  Menu(
      {this.id,
      this.translateValues,
      this.translated,
      required this.restaurantId,
      this.price,
      this.description,
      this.ingredient,
      this.isJain,
      this.isNew,
      this.isPopular,
      this.isSpecial,
      this.isSpicy,
      this.isSweet,
      this.isVeg,
      this.isNonVeg,
      this.category,
      this.menuImage,
      this.createdAt,
      this.updatedAt,
      required this.order,
      this.amounts,
      this.allergens});

  Menu.fromJson(dynamic json) {
    id = json['id'];
    restaurantId = json['restaurantId'];
    price = double.parse(json['price'].toString());
    description = json['description'];
    if (json['ingredient'] != null) {
      ingredient = [];
      json['ingredient'].forEach((v) {
        ingredient?.add(v);
      });
    }
    isJain = json['isJain'];
    isNew = json['isNew'];
    isPopular = json['isPopular'];
    isSpecial = json['isSpecial'];
    isSpicy = json['isSpicy'];
    isSweet = json['isSweet'];
    isVeg = json['isVeg'];
    isNonVeg = json['isNonVeg'];
    category = json['category'];

    if (json['menuImage'] != null) {
      menuImage = [];
      json['menuImage'].forEach((v) {
        menuImage?.add(v);
      });
    }
    if (json['amounts'] != null) {
      amounts = [];
      json['amounts'].forEach((v) {
        amounts?.add(Amount.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    order = json['order'];
    translateValues = json['translateValues'] != null
        ? TranslateValues.fromJson(json['translateValues'])
        : null;
    translated = json['translated'] != null
        ? TranslatedValues.fromJson(json['translated'])
        : null;
    if (json['allergens'] != null) {
      allergens = [];
      json['allergens'].forEach((v) {
        allergens?.add(v);
      });
    }
  }

  String? id;
  TranslateValues? translateValues;
  TranslatedValues? translated;
  String? restaurantId;
  double? price;
  String? description;
  List<String>? ingredient;
  bool? isJain;
  bool? isNew;
  bool? isPopular;
  bool? isSpecial;
  bool? isSpicy;
  bool? isSweet;
  bool? isVeg;
  int? isNonVeg;
  String? category;
  List<String>? menuImage;
  String? createdAt;
  String? updatedAt;
  late int order;
  List<Amount>? amounts;
  List<String>? allergens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['restaurantId'] = restaurantId;
    map['price'] = price;
    map['description'] = description;
    map['ingredient'] = ingredient;
    map['isJain'] = isJain;
    map['isNew'] = isNew;
    map['isPopular'] = isPopular;
    map['isSpecial'] = isSpecial;
    map['isSpicy'] = isSpicy;
    map['isSweet'] = isSweet;
    map['isVeg'] = isVeg;
    map['isNonVeg'] = isNonVeg;
    map['category'] = category;
    if (menuImage != null) {
      map['menuImage'] = menuImage?.map((v) => v).toList();
    }
    if (amounts != null) {
      map['amounts'] = amounts?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['order'] = order;
    // map['translateValues'] = translateValues?.toJson();
    map['translated'] = translated?.toJson();
    map['allergens'] = allergens;

    return map;
  }

  @override
  String toString() {
    return "Menu(restaurantId: $restaurantId, category: $category, Images: $menuImage, name: ${translateValues?.name})";
  }
}

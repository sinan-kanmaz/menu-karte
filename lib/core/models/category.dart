import 'package:qrmenu/core/models/category/translated_values.dart';

import 'category/translate_values.dart';

class MenuCategory {
  String? id;
  int? status;
  String? categoryImage;
  String? restaurantId;
  String? tab;
  TranslateValues? translateValues;
  TranslatedValues? translated;
  late int order;

  MenuCategory(
      {this.id,
      this.status,
      this.categoryImage,
      this.restaurantId,
      this.tab,
      this.translateValues,
      this.translated,
      required this.order});

  MenuCategory.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    categoryImage = json['categoryImage'];
    restaurantId = json['restaurantId'];
    tab = json['tab'];
    translateValues = json['translateValues'] != null
        ? TranslateValues.fromJson(json['translateValues'])
        : null;
    translated = json['translated'] != null
        ? TranslatedValues.fromJson(json['translated'])
        : null;
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['restaurantId'] = restaurantId;
    map['categoryImage'] = categoryImage;
    map['tab'] = tab;
    // map['translateValues'] = translateValues?.toJson();
    map['translated'] = translated?.toJson();
    map['order'] = order;

    return map;
  }

  @override
  String toString() {
    return "MenuCategory(id: $id, status: $status, restaurantId: $restaurantId, categoryImage: $categoryImage, translated: $translated, order: $order, translateValues: $translateValues)";
  }

  String getLacalName(String localeName) {
    String name = "";

    if (translated == null) {
      return translateValues!.name.toString();
    } else {
      switch (localeName) {
        case "en":
          name = translated!.name!.en!;
          break;
        case "de":
          name = translated!.name!.de!;
          break;
        case "nl":
          name = translated!.name!.nl!;
          break;
        case "tr":
          name = translated!.name!.tr!;
          break;
        default:
          name = translateValues!.name.toString();
      }
    }
    return name;
  }
}

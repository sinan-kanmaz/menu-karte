import 'package:qrmenu/core/models/restaurant/menu_tab.dart';

class Restaurant {
  late String uid;
  String? name;
  String? path;
  String? email;
  String? contactNumber;
  // String? address;
  String? description;
  String? restaurantLogo;
  List<String>? restaurantImage;
  // List<String>? menuTabs;
  int? menuStyle;
  int? restaurantStyle;
  List<MenuTab>? menuTabs;
  bool? active;

  Restaurant(
      {required this.uid,
      this.name,
      this.email,
      this.contactNumber,
      // this.address,
      this.description,
      this.restaurantLogo,
      this.restaurantImage,
      this.path,
      this.menuTabs,
      this.menuStyle,
      this.restaurantStyle,
      this.active});

  Restaurant.fromJson(dynamic json) {
    uid = json['uid'];
    name = json['name'];
    path = json['path'];
    email = json['email'];
    contactNumber = json['contact_number'];
    // address = json['address'];
    description = json['description'];
    restaurantLogo = json['restaurantLogo'];
    if (json['restaurant_image'] != null) {
      restaurantImage = [];
      json['restaurant_image'].forEach((v) {
        restaurantImage?.add(v);
      });
    }
    if (json['menuTabs'] != null) {
      menuTabs = [];
      json['menuTabs'].forEach((v) {
        menuTabs?.add(MenuTab.fromJson(v));
      });
    }
    menuStyle = json['menuStyle'];
    restaurantStyle = json['restaurantStyle'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['path'] = path;
    map['email'] = email;
    map['contact_number'] = contactNumber;
    // map['address'] = address;
    map['description'] = description;
    map['restaurantLogo'] = restaurantLogo;
    if (restaurantImage != null) {
      map['restaurant_image'] = restaurantImage?.map((v) => v).toList();
    }
    if (menuTabs != null) {
      map['menuTabs'] = menuTabs?.map((v) => v).toList();
    }
    map['menuStyle'] = menuStyle;
    map['restaurantStyle'] = restaurantStyle;
    map['active'] = active;

    return map;
  }
}

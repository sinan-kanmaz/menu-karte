import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/screens/qr_generate_screen/qrStyle/qr_style_one.dart';
import 'package:qrmenu/screens/qr_generate_screen/qrStyle/qr_style_three.dart';
import 'package:qrmenu/screens/qr_generate_screen/qrStyle/qr_style_two.dart';
import 'package:qrmenu/screens/widgets/menuStyles/menu_style_one.dart';
import 'package:qrmenu/screens/widgets/menuStyles/menu_style_three.dart';
import 'package:qrmenu/screens/widgets/menuStyles/menu_style_two.dart';

Widget getMenuComponentWidget(
    {VoidCallback? callback,
    required Menu menu,
    int? index,
    int? style,
    List<Menu>? menus}) {
  if (style == 1) {
    return MenuComponentStyleOne(
      menu: menu,
      callback: () {
        callback?.call();
      },
    );
  } else if (style == 2) {
    return MenuComponentStyleTwo(
        menuData: menu,
        callback: () {
          callback?.call();
        });
  } else if (style == 3) {
    return MenuComponentStyleThree(
      isLast: index == (menus.validate().length - 1) ? true : false,
      menuData: menu,
      callback: () {
        callback?.call();
      },
    );
  } else {
    return MenuComponentStyleOne(
      menu: menu,
      callback: () {
        callback?.call();
      },
    );
  }
}

Widget getQrStyleWidget(
    GlobalKey<State<StatefulWidget>> qrKey, String saveUrl, int style) {
  if (style == 2) {
    return QrComponentStyleTwo(
      qrKey: qrKey,
      saveUrl: saveUrl,
    );
  } else if (style == 3) {
    return QrComponentStyleThree(
      qrKey: qrKey,
      saveUrl: saveUrl,
    );
  } else {
    return QrComponentStyleOne(qrKey: qrKey, saveUrl: saveUrl);
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

class MenuListCategoryComponent extends StatelessWidget {
  final String categoryName;
  final int length;

  const MenuListCategoryComponent(
      {super.key, required this.categoryName, required this.length});

  @override
  Widget build(BuildContext context) {
    return Text(categoryName,
            style: boldTextStyle(color: AppPalette.bodyColor, size: 20))
        .paddingSymmetric(horizontal: 16);
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

import 'category_list.dart';

class RestaurantCategoriesWidget extends StatelessWidget {
  final List<MenuCategory> categories;
  final MenuCategory? selectedCategory;
  final Function(MenuCategory?) callback;

  const RestaurantCategoriesWidget(
      {super.key,
      required this.categories,
      this.selectedCategory,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.localizations!.categories} (${categories.length})',
          style: boldTextStyle(size: 20),
        ).paddingSymmetric(horizontal: 16),
        8.height,
        SizedBox(
          width: context.width(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    callback(null);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: radius(defaultRadius),
                      color: selectedCategory == null
                          ? AppPalette.primaryColor
                          : context.cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: selectedCategory == null
                                  ? context.cardColor
                                  : context.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                                  context.localizations!.all.characters.first
                                      .toUpperCase(),
                                  style: boldTextStyle(
                                      size: 20,
                                      color: context.theme.brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : AppPalette.bodyColor))
                              .center(),
                        ),
                        Text(
                          context.localizations!.all,
                          style: boldTextStyle(
                              size: 16,
                              color: selectedCategory == null
                                  ? Colors.white
                                  : context.iconColor),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 8, vertical: 8)
                      ],
                    ),
                  ),
                ).paddingOnly(top: 8, right: 8, bottom: 8),
                RestaurantCategoryListView(
                  callback: (MenuCategory? category) {
                    callback(category);
                  },
                  categories: categories,
                  selectedCategory: selectedCategory,
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ).visible(true),
      ],
    );
  }
}

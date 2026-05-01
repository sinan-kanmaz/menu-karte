import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';

class RestaurantCategoryListView extends StatelessWidget {
  final List<MenuCategory> categories;
  final MenuCategory? selectedCategory;
  final Function(MenuCategory?) callback;

  const RestaurantCategoryListView(
      {super.key,
      required this.categories,
      required this.selectedCategory,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return HorizontalList(
      physics: const NeverScrollableScrollPhysics(),
      spacing: 16,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        MenuCategory categoryData = categories[index];

        return GestureDetector(
          onTap: () {
            callback(categoryData);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            width: 100,
            decoration: BoxDecoration(
              borderRadius: radius(defaultRadius),
              color: selectedCategory?.translateValues?.name ==
                      categoryData.translateValues?.name
                  ? AppPalette.primaryColor
                  : context.cardColor,
            ),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: selectedCategory?.translateValues?.name ==
                              categoryData.translateValues?.name
                          ? context.cardColor
                          : context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: categoryData.categoryImage == null
                        ? Text(
                                categoryData.translateValues!.name
                                    .validate()[0]
                                    .toUpperCase(),
                                style: boldTextStyle(
                                    size: 20,
                                    color: context.theme.brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : AppPalette.bodyColor))
                            .center()
                        : cachedImage(categoryData.categoryImage,
                            fit: BoxFit.cover),
                  ),
                ),
                Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(
                    categories[index]
                        .getLacalName(context.localizations!.localeName),
                    style: boldTextStyle(
                        size: 14,
                        color: selectedCategory?.translateValues?.name ==
                                categoryData.translateValues?.name
                            ? Colors.white
                            : context.iconColor),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).paddingSymmetric(horizontal: 8, vertical: 8),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

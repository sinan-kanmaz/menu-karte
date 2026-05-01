import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/screens/add_category_screen.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/riverpods/selected_category_provider.dart';

class CategoryListView extends ConsumerStatefulWidget {
  final MenuTab? tab;
  const CategoryListView({super.key, this.tab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryListViewState();
}

class _CategoryListViewState extends ConsumerState<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return HorizontalList(
      physics: const NeverScrollableScrollPhysics(),
      spacing: 16,
      itemCount: ref
          .watch(categoriesProvider.notifier)
          .getCategoryListByTab(widget.tab?.en)
          .length,
      itemBuilder: (context, index) {
        MenuCategory categoryData = ref
            .watch(categoriesProvider.notifier)
            .getCategoryListByTab(widget.tab?.en)[index];

        return GestureDetector(
          onTap: () {
            ref
                .read(selectedCategoryProvider.notifier)
                .setCategory(categoryData);

            // ref
            //     .read(restaurantMenusProvider.notifier)
            //     .selectCategory(widget.tab);
          },
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: radius(defaultRadius),
                  color: ref
                              .watch(selectedCategoryProvider)
                              ?.translateValues
                              ?.name ==
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
                          color: ref
                                      .watch(selectedCategoryProvider)
                                      ?.translateValues
                                      ?.name ==
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
                        categoryData
                            .getLacalName(context.localizations!.localeName),
                        style: boldTextStyle(
                            size: 14,
                            color: ref
                                        .watch(selectedCategoryProvider)
                                        ?.translateValues
                                        ?.name ==
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
              IconButton(
                onPressed: () {
                  context.push(AddCategoryScreen.routeName,
                      extra: categoryData);
                },
                icon: const Icon(Icons.edit),
              )
            ],
          ),
        );
      },
    );
  }
}

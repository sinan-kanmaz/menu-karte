import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/screens/add_category_screen.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/riverpods/selected_category_provider.dart';
import 'package:qrmenu/screens/widgets/add_new_item.dart';

import 'category_list.dart';

class CategoriesWidget extends ConsumerStatefulWidget {
  final MenuTab? tab;
  const CategoriesWidget({super.key, this.tab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesWidgetState();
}

class _CategoriesWidgetState extends ConsumerState<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.localizations!.categories} (${ref.read(categoriesProvider.notifier).getCategoryListByTab(widget.tab?.en).length})',
              style: context.appTheme.appTextTheme.boldTextStyle!
                  .copyWith(fontSize: 20),
            ),
            AddNewComponentItem(onTap: () {
              context.push(AddCategoryScreen.routeName);
            }),
          ],
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
                    ref
                        .read(selectedCategoryProvider.notifier)
                        .setCategory(null);
                    // ref
                    //     .read(restaurantMenusProvider.notifier)
                    //     .selectCategory(widget.tab);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: radius(defaultRadius),
                      color: ref.watch(selectedCategoryProvider) == null
                          ? AppPalette.primaryColor
                          : context.cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: ref.read(selectedCategoryProvider) == null
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
                              color: ref.read(selectedCategoryProvider) == null
                                  ? Colors.white
                                  : context.iconColor),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 8, vertical: 8)
                      ],
                    ),
                  ),
                ).paddingOnly(top: 8, right: 8, bottom: 8),
                CategoryListView(tab: widget.tab),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ).visible(ref.watch(categoriesProvider).isNotEmpty),
        Text(context.localizations!.noCategory)
            .visible(ref.watch(categoriesProvider).isEmpty)
            .center()
      ],
    );
  }
}

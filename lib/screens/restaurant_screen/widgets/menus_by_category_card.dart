import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/get_style_widget.dart';
import 'package:qrmenu/screens/dashboard_screen/riverpods/menu_list_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/widgets/no_data_widget.dart';

class MenusByCategoryCard extends ConsumerWidget {
  final MenuCategory category;
  final Restaurant restaurant;
  const MenusByCategoryCard(
      {super.key, required this.category, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: context.cardColor, borderRadius: radius(defaultRadius)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.getLacalName(context.localizations!.localeName),
                  style: boldTextStyle(color: AppPalette.bodyColor, size: 20))
              .paddingSymmetric(horizontal: 16),
          ref
              .watch(
                menuListProvider(restaurant.uid, category.id),
              )
              .when(
                  data: (data) {
                    if (data.isEmpty) {
                      return NoMenuComponent(
                              categoryName: category.getLacalName(
                                  context.localizations!.localeName))
                          .center();
                    }
                    return Responsive(
                      mobile: Wrap(
                        alignment: WrapAlignment.start,
                        children: List.generate(data.length, (i) {
                          Menu menuData = data[i];
                          return getMenuComponentWidget(
                              menu: menuData,
                              index: i,
                              style: restaurant.menuStyle);
                        }),
                      ),
                      web: GridView.builder(
                        itemBuilder: (BuildContext context, int i) {
                          Menu menuData = data[i];

                          return getMenuComponentWidget(
                              menu: menuData,
                              index: i,
                              style: restaurant.menuStyle);
                        },
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 220,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    );
                  },
                  error: (error, _) => Center(child: Text(error.toString())),
                  loading: () => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ))
        ],
      ).paddingSymmetric(vertical: 16),
    );
  }
}

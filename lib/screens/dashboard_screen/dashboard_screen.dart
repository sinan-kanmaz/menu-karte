import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/global_providers/user_state_provider.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/get_style_widget.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/riverpods/menu_list_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/riverpods/restaurant_menus_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/widgets/no_data_widget.dart';
import 'package:qrmenu/screens/new_menu_screen/add_menu_item_creen.dart';
import 'package:qrmenu/screens/qr_generate_screen/qr_generate_screen.dart';
import 'package:qrmenu/screens/settings_screen/setting_screen.dart';

import 'widgets/menu_list_category_component.dart';
import 'widgets/categories_widget.dart';
import '../widgets/add_new_item.dart';
import 'riverpods/selected_category_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  MenuTab? selectedTab;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userStateProvider, (previous, next) {
      if (next?.menuTabs != null) {
        if (next!.menuTabs!.isNotEmpty) {
          selectedTab = next.menuTabs!.first;
        }
        setState(() {});
      }
    });
    ref.watch(selectedCategoryProvider);

    final user = ref.watch(userStateProvider);

    return Consumer(builder: (context, ref, _) {
      return DefaultTabController(
        length: user?.menuTabs == null ? 0 : user!.menuTabs!.length,
        child: DoublePressBackWidget(
          message: "Press back again to exit app",
          child: Scaffold(
            appBar: appBarWidget(
              "${context.localizations!.hello} ${ref.read(authStateProvider)!.displayName}",
              titleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.localizations!.hello} ${ref.read(authStateProvider)!.displayName}',
                    style: boldTextStyle(
                        size: 18,
                        color: context.theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppPalette.headingColor),
                  ),
                  Text(
                    context.localizations!.welcomeBackHaveANiceDay,
                    style: secondaryTextStyle(
                        color: AppPalette.bodyColor, size: 12),
                  )
                ],
              ).paddingTop(12),
              showBack: false,
              elevation: 0,
              actions: [
                if (ref.watch(authStateProvider) != null)
                  IconButton(
                    onPressed: () {
                      context.push(QrGenerateScreen.routeName);
                    },
                    icon: Icon(Icons.qr_code, color: context.iconColor),
                  ),
                if (ref.watch(authStateProvider) != null)
                  Image.asset(
                    'assets/images/ic_Setting.png',
                    height: 24,
                    width: 24,
                    color: context.iconColor,
                  ).paddingOnly(left: 16, right: 16).onTap(() {
                    context.push(SettingScreen.routeName);
                  }),
              ],
              color: context.scaffoldBackgroundColor,
              bottom: user?.menuTabs == null
                  ? null
                  : TabBar(
                      onTap: (v) {
                        ref
                            .read(selectedCategoryProvider.notifier)
                            .setCategory(null);
                        selectedTab = user.menuTabs![v];
                        setState(() {});
                      },
                      tabs: List.generate(
                        user!.menuTabs!.length,
                        (index) => Tab(
                          text: user.menuTabs![index]
                              .getLacalName(context.localizations!.localeName)
                              .toUpperCase(),
                        ),
                      ),
                    ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(
                      color: context.dividerColor,
                      indent: 16,
                      endIndent: 16,
                      thickness: 1),
                  16.height,
                  if (selectedTab?.en != "Uncategorized")
                    CategoriesWidget(tab: selectedTab),
                  16.height,
                  if (ref.watch(categoriesProvider).isNotEmpty)
                    Row(
                      children: [
                        Text(
                          context.localizations!.menu_items,
                          style:
                              boldTextStyle(size: 20, color: context.iconColor),
                        ).expand(),
                        AddNewComponentItem(
                          onTap: () =>
                              context.push(AddMenuItemScreen.routeName),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  16.height,
                  if (ref.watch(categoriesProvider).isNotEmpty)
                    Stack(
                      children: [
                        if (ref.watch(selectedCategoryProvider) == null)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ref
                                .watch(categoriesProvider.notifier)
                                .getCategoryListByTab(selectedTab?.en)
                                .length,
                            itemBuilder: (_, i) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: context.cardColor,
                                    borderRadius: radius(defaultRadius)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (selectedTab?.en != "Uncategorized")
                                      MenuListCategoryComponent(
                                        categoryName: ref
                                            .watch(categoriesProvider.notifier)
                                            .getCategoryListByTab(
                                                selectedTab?.en)[i]
                                            .translated!
                                            .name!
                                            .getStringName(context
                                                .localizations!.localeName),
                                        length: 0,
                                      ),
                                    if (selectedTab?.en == "Uncategorized")
                                      ref
                                          .watch(
                                            menuListProvider(
                                                ref
                                                    .read(authStateProvider)!
                                                    .uid,
                                                "Uncategorized"),
                                          )
                                          .when(
                                            data: (data) {
                                              return Responsive(
                                                mobile: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: List.generate(
                                                      data.length, (i) {
                                                    Menu menuData = data[i];
                                                    int? style =
                                                        user?.menuStyle;
                                                    return getMenuComponentWidget(
                                                        callback: () {
                                                          if (user != null) {
                                                            context.push(
                                                                AddMenuItemScreen
                                                                    .routeName,
                                                                extra:
                                                                    menuData);
                                                          }
                                                        },
                                                        menu: menuData,
                                                        index: i,
                                                        style: style);
                                                  }),
                                                ),
                                                web: GridView.builder(
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    Menu menuData = data[i];
                                                    int? style =
                                                        user?.menuStyle;

                                                    return getMenuComponentWidget(
                                                        callback: () {
                                                          if (user != null) {
                                                            context.push(
                                                                AddMenuItemScreen
                                                                    .routeName,
                                                                extra:
                                                                    menuData);
                                                          }
                                                        },
                                                        menu: menuData,
                                                        index: i,
                                                        style: style);
                                                  },
                                                  itemCount: data.length,

                                                  // categoryMenus.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    mainAxisSpacing: 16,
                                                    mainAxisExtent:
                                                        getMainAxisExtent(),
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                ),
                                              );
                                            },
                                            error: (error, _) {
                                              return Center(
                                                child: Text(error.toString()),
                                              );
                                            },
                                            loading: () =>
                                                const SizedBox.shrink(),
                                          ),
                                    if (selectedTab?.en != "Uncategorized")
                                      ref
                                          .watch(
                                            menuListProvider(
                                                ref
                                                    .read(authStateProvider)!
                                                    .uid,
                                                ref
                                                    .watch(categoriesProvider
                                                        .notifier)
                                                    .getCategoryListByTab(
                                                        selectedTab?.en)[i]
                                                    .id),
                                          )
                                          .when(
                                            data: (data) {
                                              return Responsive(
                                                mobile: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: List.generate(
                                                      data.length, (i) {
                                                    Menu menuData = data[i];
                                                    int? style =
                                                        user?.menuStyle;
                                                    return getMenuComponentWidget(
                                                        callback: () {
                                                          if (user != null) {
                                                            context.push(
                                                                AddMenuItemScreen
                                                                    .routeName,
                                                                extra:
                                                                    menuData);
                                                          }
                                                        },
                                                        menu: menuData,
                                                        index: i,
                                                        style: style);
                                                  }),
                                                ),
                                                web: GridView.builder(
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    Menu menuData = data[i];
                                                    int? style =
                                                        user?.menuStyle;

                                                    return getMenuComponentWidget(
                                                        callback: () {
                                                          if (user != null) {
                                                            context.push(
                                                                AddMenuItemScreen
                                                                    .routeName,
                                                                extra:
                                                                    menuData);
                                                          }
                                                        },
                                                        menu: menuData,
                                                        index: i,
                                                        style: style);
                                                  },
                                                  itemCount: data.length,

                                                  // categoryMenus.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    mainAxisSpacing: 16,
                                                    mainAxisExtent:
                                                        getMainAxisExtent(),
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                ),
                                              );
                                            },
                                            error: (error, _) {
                                              return Center(
                                                child: Text(error.toString()),
                                              );
                                            },
                                            loading: () =>
                                                const SizedBox.shrink(),
                                          )
                                  ],
                                ).paddingSymmetric(vertical: 16),
                              );
                            },
                          ),
                        if (ref.watch(selectedCategoryProvider) != null)
                          Container(
                            decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: radius(defaultRadius)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MenuListCategoryComponent(
                                  categoryName: ref
                                      .watch(selectedCategoryProvider)!
                                      .getLacalName(
                                          context.localizations!.localeName),
                                  length: 0,
                                ),
                                ref
                                    .watch(
                                      menuListProvider(
                                          ref.read(authStateProvider)!.uid,
                                          ref
                                              .watch(selectedCategoryProvider)!
                                              .id),
                                    )
                                    .when(
                                      data: (data) {
                                        return Responsive(
                                          mobile: Wrap(
                                            alignment: WrapAlignment.start,
                                            children:
                                                List.generate(data.length, (i) {
                                              Menu menuData = data[i];
                                              return getMenuComponentWidget(
                                                callback: () {},
                                                menu: menuData,
                                                index: i,
                                              );
                                            }),
                                          ),
                                          web: GridView.builder(
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              Menu menuData = data[i];

                                              return getMenuComponentWidget(
                                                callback: () {},
                                                menu: menuData,
                                                index: i,
                                              );
                                            },
                                            itemCount: data.length,

                                            // categoryMenus.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 16,
                                              mainAxisExtent:
                                                  getMainAxisExtent(),
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                          ),
                                        );
                                      },
                                      error: (error, _) => Center(
                                        child: Text(error.toString()),
                                      ),
                                      loading: () => const SizedBox.shrink(),
                                    )
                              ],
                            ).paddingSymmetric(vertical: 16),
                          ),
                        NoMenuComponent(
                          categoryName: ref
                              .watch(selectedCategoryProvider)
                              ?.getLacalName(context.localizations!.localeName),
                        ).center().visible(
                            ref.watch(restaurantMenusProvider).isEmpty),
                        Loader().center().visible(false),
                      ],
                    ),
                ],
              ).visible(true),
            ),
          ),
        ),
      );
    });
  }

  double getMainAxisExtent() {
    // if (appStore.selectedMenuStyle == language.lblMenuStyle1) {
    //   return 220;
    // } else if (appStore.selectedMenuStyle == language.lblMenuStyle2) {
    //   return 150;
    // } else if (appStore.selectedMenuStyle == language.lblMenuStyle3) {
    //   return 180;
    // } else {
    //   return 220;
    // }
    return 220;
  }
}

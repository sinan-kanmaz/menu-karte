import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_icons/flutter_app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:qrmenu/core/services/analytics_service.dart';
import 'package:qrmenu/core/services/cloud_functions_service.dart';
import 'package:qrmenu/screens/restaurant_screen/widgets/style_two_widget.dart';
import 'package:qrmenu/screens/settings_screen/setting_screen.dart';

import 'widgets/categories_widget.dart';
import 'widgets/menus_by_category_card.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  List<MenuCategory> categoryList = [];
  List<Menu> menus = [];
  Restaurant? restaurant;
  MenuTab? selectedTab;
  MenuCategory? _selectedCategory;
  final _flutterAppIconsPlugin = FlutterAppIcons();
  late List<MenuTab> tabs;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    tabs = [];
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
      getMenus();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMenus() async {
    ref.read(analyticsServiceProvider).saveQrReading(widget.restaurantId);
    restaurant = await ref
        .read(firestoreRepositoryProvider)
        .getRestaurantByPath(widget.restaurantId);

    ref.read(cloudFunctionsServiceProvider).saveQrReading(restaurant!.uid);
    if (restaurant?.restaurantLogo != null) {
      _flutterAppIconsPlugin.setIcon(icon: restaurant!.restaurantLogo!);
    }
    if (restaurant?.menuTabs != null) {
      if (restaurant!.menuTabs!.length > 1) {
        selectedTab = restaurant!.menuTabs!.first;

        for (MenuTab tab in restaurant!.menuTabs!) {
          if (tab.en != "Uncategorized") {
            tabs.add(tab);
          }
        }
      }
    }
    setState(() {});
    if (restaurant != null) {
      categoryList = await ref
          .read(firestoreRepositoryProvider)
          .getCategories(restaurant!.uid);

      menus =
          await ref.read(firestoreRepositoryProvider).getMenus(restaurant!.uid);

      for (MenuCategory category in categoryList) {
        List<Menu> categoryMenus = [];
        for (Menu menu in menus) {
          if (menu.category == category.translateValues?.name) {
            categoryMenus.add(menu);
          }
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (restaurant == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (!restaurant!.active!) {
      return const Scaffold(
        body: Center(
          child: Text('This restauarnt is not active'),
        ),
      );
    }

    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: restaurant!.name,
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    if (restaurant?.restaurantStyle == 1) {
      return StyleTwoWidget(
        restaurant: restaurant!,
        categories: categoryList,
        menus: menus,
        tabs: tabs,
      );
    }

    return DefaultTabController(
      length: tabs.isEmpty ? tabs.length : 0,
      child: Scaffold(
        appBar: appBarWidget(restaurant!.name.toString(),
            elevation: 0,
            color: context.scaffoldBackgroundColor,
            showBack: false,
            actions: [
              Image.asset(
                'assets/images/ic_Setting.png',
                height: 24,
                width: 24,
                color: context.iconColor,
              ).paddingOnly(left: 16, right: 16).onTap(() {
                context.push(SettingScreen.routeName);
              }),
            ],
            bottom: tabs.isNotEmpty
                ? TabBar(
                    onTap: (i) {
                      selectedTab = tabs[i];
                      _selectedCategory = null;
                      setState(() {});
                    },
                    tabs: List.generate(
                      tabs.length,
                      (index) => Tab(
                        text: tabs[index]
                            .getLacalName(context.localizations!.localeName),
                      ),
                    ))
                : null),
        body: tabs.isNotEmpty
            ? RestaurantMenusWidget(
                categoryList: categoryList,
                restaurant: restaurant!,
                selectedTab: selectedTab,
                selectedCategory: _selectedCategory,
                selectCategory: (MenuCategory? category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              )
            : RestaurantMenusWidget(
                categoryList: categoryList,
                restaurant: restaurant!,
                selectedCategory: _selectedCategory,
                selectCategory: (MenuCategory? category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
      ),
    );
  }
}

class RestaurantMenusWidget extends ConsumerWidget {
  final List<MenuCategory> categoryList;
  final MenuTab? selectedTab;
  final Restaurant restaurant;
  final MenuCategory? selectedCategory;
  final Function(MenuCategory?) selectCategory;

  const RestaurantMenusWidget(
      {super.key,
      required this.categoryList,
      this.selectedTab,
      required this.restaurant,
      this.selectedCategory,
      required this.selectCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
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
          if (categoryList.isNotEmpty)
            RestaurantCategoriesWidget(
                callback: (MenuCategory? category) {
                  selectCategory(category);
                },
                categories: getCategoryListByTab(selectedTab?.en),
                selectedCategory: selectedCategory),
          16.height,
          Text(
            context.localizations!.menu_items,
            style: boldTextStyle(size: 20, color: context.iconColor),
          ).paddingSymmetric(horizontal: 16),
          16.height,
          if (selectedCategory == null)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: getCategoryListByTab(selectedTab?.en).length,
              itemBuilder: (_, i) {
                return MenusByCategoryCard(
                    category: getCategoryListByTab(selectedTab?.en)[i],
                    restaurant: restaurant);
              },
            ).visible(true),
          if (selectedCategory != null)
            MenusByCategoryCard(
                category: selectedCategory!, restaurant: restaurant)
        ],
      ),
    );
  }

  List<MenuCategory> getCategoryListByTab(String? tab) {
    if (tab == null) {
      return categoryList;
    } else {
      List<MenuCategory> categories = [];

      for (MenuCategory category in categoryList) {
        if (category.tab == tab) {
          categories.add(category);
        }
      }

      return categories;
    }
  }
}

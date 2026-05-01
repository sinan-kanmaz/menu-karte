import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/user_state_provider.dart';
import 'package:qrmenu/core/models/restaurant.dart';

import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/screens/widgets/menuStyles/menu_style_one.dart';
import 'package:qrmenu/screens/widgets/menuStyles/menu_style_three.dart';
import 'package:qrmenu/screens/widgets/menuStyles/menu_style_two.dart';

class MenuStyleScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const MenuStyleScreen({super.key, required this.restaurant});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MenuStyleScreenState();
}

class _MenuStyleScreenState extends ConsumerState<MenuStyleScreen> {
  int? selectedIndex;
  int? _selectedRestaurantStyle;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      if (widget.restaurant.restaurantStyle != null) {
        _selectedRestaurantStyle = widget.restaurant.restaurantStyle!;
        setState(() {});
      }

      if (widget.restaurant.menuStyle != null) {
        selectedIndex = widget.restaurant.menuStyle! - 1;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              context.localizations!.restaurantStyle,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.done, color: context.iconColor),
                onPressed: () async {
                  if (selectedIndex == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog.adaptive(
                        content: Text(
                          context.localizations!.pleaseSelectAMenuStyle,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(context.localizations!.ok),
                          )
                        ],
                      ),
                    );

                    return;
                  }
                  await ref.read(userStateProvider.notifier).setMenuStyle(
                      selectedIndex! + 1, _selectedRestaurantStyle);
                  if (mounted) finish(context);
                },
              )
            ],
            bottom: TabBar(tabs: [
              Tab(
                text: context.localizations!.restaurantStyle,
              ),
              Tab(text: context.localizations!.menuStyle),
            ])),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1, color: context.dividerColor),
                  16.height,
                  Text(
                    context.localizations!.selectMenuStyles,
                    style: context.appTheme.appTextTheme.boldTextStyle,
                  ),
                  16.height,
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(2, (i) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: radius(defaultRadius),
                          color: i == _selectedRestaurantStyle
                              ? AppPalette.primaryColor
                              : context.cardColor,
                        ),
                        width: context.width() / 2 - 24,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '${context.localizations!.style} ${i + 1}',
                          style: boldTextStyle(
                              color: i == _selectedRestaurantStyle
                                  ? Colors.white
                                  : AppPalette.bodyColor),
                          textAlign: TextAlign.center,
                        ),
                      ).onTap(() {
                        _selectedRestaurantStyle = i;
                        setState(() {});
                      }, borderRadius: radius(defaultRadius));
                    }),
                  ),
                  20.height,
                  Image.asset(getMenuStyleImage())
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1, color: context.dividerColor),
                  16.height,
                  Text(
                    context.localizations!.selectMenuStyles,
                    style: context.appTheme.appTextTheme.boldTextStyle,
                  ),
                  16.height,
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(3, (i) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: radius(defaultRadius),
                          color: i == selectedIndex
                              ? AppPalette.primaryColor
                              : context.cardColor,
                        ),
                        width: context.width() / 2 - 24,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '${context.localizations!.style} ${i + 1}',
                          style: boldTextStyle(
                              color: i == selectedIndex
                                  ? Colors.white
                                  : AppPalette.bodyColor),
                          textAlign: TextAlign.center,
                        ),
                      ).onTap(() {
                        selectedIndex = i;
                        setState(() {});
                      }, borderRadius: radius(defaultRadius));
                    }),
                  ),
                  20.height,
                  Container(
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: radius(defaultRadius)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localizations!.selectedMenuStyle,
                          style: boldTextStyle(),
                        ),
                        16.height,
                        getSampleMenu(context),
                      ],
                    ),
                  ),
                  20.height,
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSampleMenu(BuildContext context) {
    if (selectedIndex == 0) {
      return const SampleMenuOne(
          // menu: Menu(
          //     restaurantId: "1",
          //     name: "Example Menu Title 1",
          //     price: 20,
          //     description: "Example Menu Description 1"),
          );
    } else if (selectedIndex == 1) {
      return const SampleMenuTwo(
          // menuData: Menu(
          //     restaurantId: "1",
          //     name: "Example Menu Title 2",
          //     price: 20,
          //     description: "Example Menu Description 2"),
          );
    } else {
      return const SampleMenuThree(
          // isLast: false,
          // menuData: Menu(
          //     restaurantId: "1",
          //     name: "Example Menu Title 3",
          //     price: 20,
          //     description: "Example Menu Description 3"),
          );
    }
  }

  String getMenuStyleImage() {
    switch (_selectedRestaurantStyle) {
      case 1:
        return "assets/images/restaurant-style-1.png";

      default:
        return "assets/images/restaurant-style-2.png";
    }
  }
}

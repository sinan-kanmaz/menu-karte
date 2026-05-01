// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:printing/printing.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

import 'widgets/style_one.dart';
import 'widgets/style_three.dart';
import 'widgets/style_two.dart';

class PrintMenuScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const PrintMenuScreen({super.key, required this.restaurant});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrintMenuScreenState();
}

class _PrintMenuScreenState extends ConsumerState<PrintMenuScreen> {
  List<MenuCategory> categoryList = [];
  Restaurant? restaurant;
  MenuTab? selectedTab;
  late Map<String, List<Menu>> menus;
  late List<MenuCategory> categories;
  List<Menu> menuList = [];
  int printingStyle = 1;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    menus = {};
    categories = [];
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
      getMenus();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getMenus() async {
    restaurant = widget.restaurant;

    if (restaurant?.menuTabs != null) {
      selectedTab = restaurant!.menuTabs!.first;
    }

    if (restaurant != null) {
      categoryList = await ref
          .read(firestoreRepositoryProvider)
          .getCategories(restaurant!.uid);

      menuList =
          await ref.read(firestoreRepositoryProvider).getMenus(restaurant!.uid);

      for (MenuCategory category in categoryList) {
        if (selectedTab?.en == category.tab) {
          List<Menu> categoryMenus = [];
          for (Menu menu in menuList) {
            if (menu.category == category.id) {
              categoryMenus.add(menu);
            }
          }
          menus[category.translated!.name!.de!] = categoryMenus;
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.localizations!.printMenu,
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        showBack: Navigator.canPop(context) ? true : false,
        titleTextStyle: boldTextStyle(
            size: 18,
            color: context.theme.brightness == Brightness.dark
                ? Colors.white
                : AppPalette.headingColor),
      ),
      body: menus.isEmpty
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (restaurant?.menuTabs != null)
                    if (restaurant!.menuTabs!.isNotEmpty)
                      Text(
                        context.localizations!.selectAMenu,
                        style: context.appTheme.appTextTheme.boldTextStyle,
                      ),
                  if (restaurant?.menuTabs != null)
                    if (restaurant!.menuTabs!.isNotEmpty) buildMenuTabs(),
                  Text(
                    context.localizations!.selectMenuStyles,
                    style: context.appTheme.appTextTheme.boldTextStyle,
                  ),
                  buildPrintStyle(),
                  buildPreview()
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (printingStyle == 1) {
            showDialog(
              context: context,
              builder: (context) => PdfPreview(
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.localizations!.cancel),
                  )
                ],
                build: (format) => generatePdfStyleOne(format, menus),
              ),
            );
          }
          if (printingStyle == 2) {
            showDialog(
              context: context,
              builder: (context) => PdfPreview(
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.localizations!.cancel),
                  )
                ],
                build: (format) => generatePdfStyle2(format, menus),
              ),
            );
          }
          if (printingStyle == 3) {
            showDialog(
              context: context,
              builder: (context) => PdfPreview(
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.localizations!.cancel),
                  )
                ],
                build: (format) => generatePdfStyleThree(format, menus),
              ),
            );
          }
        },
        child: const Icon(Icons.print),
      ),
    );
  }

  buildMenuTabs() {
    return Wrap(
        children: List.generate(restaurant!.menuTabs!.length, (index) {
      MenuTab tab = restaurant!.menuTabs![index];
      return Container(
        decoration: BoxDecoration(
          borderRadius: radius(defaultRadius),
          color: selectedTab?.en == tab.en
              ? AppPalette.primaryColor
              : context.cardColor,
        ),
        width: 250,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Text(
          tab.getLacalName(context.localizations!.localeName),
          style: boldTextStyle(
              color: selectedTab?.en == tab.en
                  ? Colors.white
                  : AppPalette.bodyColor),
          textAlign: TextAlign.center,
        ),
      ).onTap(
        () {
          selectedTab = tab;
          changeTab();
        },
        borderRadius: radius(defaultRadius),
      );
    }));
  }

  changeTab() async {
    menus = {};
    for (MenuCategory category in categoryList) {
      if (selectedTab?.en == category.tab) {
        List<Menu> categoryMenus = [];
        for (Menu menu in menuList) {
          if (menu.category == category.id) {
            categoryMenus.add(menu);
          }
        }
        menus[category.translated!.name!.de!] = categoryMenus;
      }
    }
    setState(() {});
  }

  buildPrintStyle() {
    return Wrap(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: radius(defaultRadius),
          color:
              printingStyle == 1 ? AppPalette.primaryColor : context.cardColor,
        ),
        width: 250,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Text(
          "Style 1",
          style: boldTextStyle(
              color: printingStyle == 1 ? Colors.white : AppPalette.bodyColor),
          textAlign: TextAlign.center,
        ),
      ).onTap(
        () {
          printingStyle = 1;
          setState(() {});
        },
        borderRadius: radius(defaultRadius),
      ),
      StyleButtonWidget(printingStyle: printingStyle, text: "Style 2", index: 2)
          .onTap(
        () {
          printingStyle = 2;
          setState(() {});
        },
        borderRadius: radius(defaultRadius),
      ),
      StyleButtonWidget(printingStyle: printingStyle, text: "Style 3", index: 3)
          .onTap(
        () {
          printingStyle = 3;
          setState(() {});
        },
        borderRadius: radius(defaultRadius),
      ),
    ]);
  }

  buildPreview() {
    String path = "assets/images/menu-preview-1.png";
    switch (printingStyle) {
      case 1:
        path = "assets/images/menu-preview-1.png";
        break;
      case 2:
        path = "assets/images/menu-preview-2.png";
        break;
      case 3:
        path = "assets/images/menu-preview-3.png";
        break;
      default:
        path = "assets/images/menu-preview-1.png";
    }

    return Image.asset(path);
  }
}

class StyleButtonWidget extends StatelessWidget {
  final String text;
  final int printingStyle;
  final int index;

  const StyleButtonWidget(
      {super.key,
      required this.printingStyle,
      required this.text,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius(defaultRadius),
        color: printingStyle == index
            ? AppPalette.primaryColor
            : context.cardColor,
      ),
      width: 250,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(
        text,
        style: boldTextStyle(
            color:
                printingStyle == index ? Colors.white : AppPalette.bodyColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}

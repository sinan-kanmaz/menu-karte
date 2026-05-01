import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/settings_box.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/restaurant.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrmenu/screens/widgets/full_screen_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StyleTwoWidget extends StatefulWidget {
  final Restaurant restaurant;
  final List<MenuCategory> categories;
  final List<Menu> menus;
  final List<MenuTab> tabs;
  const StyleTwoWidget(
      {super.key,
      required this.restaurant,
      required this.categories,
      required this.menus,
      required this.tabs});

  @override
  State<StyleTwoWidget> createState() => _StyleTwoWidgetState();
}

class _StyleTwoWidgetState extends State<StyleTwoWidget> {
  MenuCategory? selectedCategory;
  late Map<String, List<Menu>> menus;

  MenuTab? _selectedTab;
  late List<MenuCategory> categories;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  void initState() {
    super.initState();

    menus = {};
    categories = [];
    setMenusByCategory();

    itemPositionsListener.itemPositions.addListener(() {
      int index = itemPositionsListener.itemPositions.value.first.index;

      selectedCategory = categories[index];
      setState(() {});
    });

    scrollOffsetListener.changes.listen((event) {});
  }

  setMenusByCategory() {
    menus = {};
    categories = [];

    if (widget.tabs.isNotEmpty) {
      _selectedTab ??= widget.tabs.first;

      for (MenuCategory category in widget.categories) {
        if (category.tab == _selectedTab?.en) {
          categories.add(category);
          List<Menu> menusByCategory = [];
          for (Menu menu in widget.menus) {
            if (menu.category == category.id) {
              menusByCategory.add(menu);
            }
          }
          menus[category.id!] = menusByCategory;
        }
      }
    } else {
      categories = widget.categories;
      for (MenuCategory category in widget.categories) {
        List<Menu> menusByCategory = [];
        for (Menu menu in widget.menus) {
          if (menu.category == category.id) {
            menusByCategory.add(menu);
          }
        }
        menus[category.id!] = menusByCategory;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setMenusByCategory();

    return Consumer(builder: (context, ref, _) {
      return DefaultTabController(
        length: widget.tabs.isNotEmpty ? widget.tabs.length : 0,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(1, 23, 15, 1),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.restaurant.name.toString(),
            ),
            bottom: widget.tabs.isNotEmpty
                ? TabBar(
                    onTap: (i) {
                      _selectedTab = widget.tabs[i];
                      setMenusByCategory();
                      setState(() {});
                    },
                    labelStyle: const TextStyle(fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontSize: 10),
                    tabs: List.generate(
                      widget.tabs.length,
                      (index) => Tab(
                        text: widget.tabs[index]
                            .getLacalName(context.localizations!.localeName)
                            .toUpperCase(),
                      ),
                    ),
                    labelColor: Colors.white,
                  )
                : null,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<Locale>(
                  dropdownColor: const Color.fromRGBO(1, 23, 15, 1),
                  value: Locale(context.localizations!.localeName),
                  items: AppLocalizations.supportedLocales
                      .map(
                        (e) => DropdownMenuItem<Locale>(
                          value: e,
                          child: Text(
                            AppConstant.getLocaleName(e.languageCode),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    ref
                        .read(settingsBoxProvider)
                        .put("language", v!.languageCode);
                  },
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              itemScrollController.scrollTo(
                                  index: index,
                                  duration: const Duration(milliseconds: 500));
                              // selectedCategory = categories[index];

                              // controller.scrollToIndex(index,
                              //     preferPosition: AutoScrollPosition.begin);
                              // Scrollable.ensureVisible(
                              //     keys[selectedCategory!.id!]!.currentContext!,
                              //     duration: const Duration(milliseconds: 500));

                              // setState(() {});
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: selectedCategory?.id ==
                                          categories[index].id
                                      ? const Color.fromRGBO(183, 139, 80, 1)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(52, 70, 64, 1))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (categories[index].categoryImage != null)
                                    CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        categories[index].categoryImage!,
                                      ),
                                      // child: cachedImage(
                                      //     categories[index].categoryImage,
                                      //     height: 50,
                                      //     width: 50,
                                      //     radius: 100),
                                    ),
                                  Text(
                                    categories[index]
                                        .getLacalName(
                                            context.localizations!.localeName)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
              Expanded(
                child: ScrollablePositionedList.builder(
                  // controller: controller,
                  itemScrollController: itemScrollController,
                  itemCount: menus.length,

                  scrollOffsetController: scrollOffsetController,
                  itemPositionsListener: itemPositionsListener,
                  scrollOffsetListener: scrollOffsetListener,
                  itemBuilder: (context, index) {
                    String key = menus.keys.toList()[index];
                    List<Menu> menuByCategory = menus.values.toList()[index];
                    menuByCategory.sort((a, b) => a.order.compareTo(b.order));

                    return CategoryItem(
                        category: getCategoryName(key), menus: menuByCategory);
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  MenuCategory getCategoryName(String id) {
    MenuCategory? selectedCategory;
    for (MenuCategory category in widget.categories) {
      if (category.id == id) {
        selectedCategory = category;
      }
    }
    return selectedCategory!;
  }
}

class CategoryItem extends StatelessWidget {
  final MenuCategory category;
  final List<Menu> menus;
  const CategoryItem({super.key, required this.category, required this.menus});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        SvgPicture.asset("assets/svg/menu_divider.svg"),
        const SizedBox(height: 30),
        Text(
          category.getLacalName(context.localizations!.localeName),
          textAlign: TextAlign.center,
          style: GoogleFonts.prata(
              fontSize: 27,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(202, 158, 103, 1)),
        ),
        if (category.translated?.description != null)
          Text(
            category.translated!.description!
                .getStringName(context.localizations!.localeName),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(255, 255, 255, 0.75),
            ),
          ),
        Column(
          children: List.generate(
            menus.length,
            (menuIndex) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Column(
                children: [
                  // SelectableText(
                  //   menus[menuIndex].id.toString(),
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.prata(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white),
                  // ),
                  if (menus[menuIndex].menuImage != null)
                    if (menus[menuIndex].menuImage!.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          menus[menuIndex].menuImage!.length,
                          (imageIndex) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FullScreenWidget(
                              disposeLevel: DisposeLevel.Low,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Hero(
                                  tag: menuIndex.toString(),
                                  child: cachedImage(
                                      menus[menuIndex].menuImage![imageIndex],
                                      height: 200,
                                      width: 200,
                                      radius: 20,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                  Text.rich(
                    TextSpan(
                      text: menus[menuIndex]
                          .translated!
                          .name!
                          .getStringName(context.localizations!.localeName),
                      children: menus[menuIndex].allergens == null
                          ? null
                          : List.generate(
                              menus[menuIndex].allergens!.length,
                              (allergenIndex) {
                                String text;

                                if (allergenIndex == 0) {
                                  text = menus[menuIndex]
                                      .allergens![allergenIndex]
                                      .toString();
                                } else {
                                  text =
                                      ", ${menus[menuIndex].allergens![allergenIndex]}";
                                }

                                return TextSpan(
                                  text: text,
                                  // textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.5),
                                  ),
                                );
                              },
                            ),
                      style: GoogleFonts.prata(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             menus[menuIndex].translated!.name!.getStringName(
                  //                 context.localizations!.localeName),
                  //             textAlign: TextAlign.center,
                  //             style: GoogleFonts.prata(
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Colors.white),
                  //           ),
                  //           if (menus[menuIndex].allergens != null)
                  //             const SizedBox(width: 5),
                  //           if (menus[menuIndex].allergens != null)
                  //             Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: List.generate(
                  //                 menus[menuIndex].allergens!.length,
                  //                 (allergenIndex) {
                  //                   String text;

                  //                   if (allergenIndex == 0) {
                  //                     text = menus[menuIndex]
                  //                         .allergens![allergenIndex]
                  //                         .toString();
                  //                   } else {
                  //                     text =
                  //                         ", ${menus[menuIndex].allergens![allergenIndex]}";
                  //                   }

                  //                   return Text(
                  //                     text,
                  //                     textAlign: TextAlign.center,
                  //                     style: GoogleFonts.poppins(
                  //                       fontSize: 12,
                  //                       fontWeight: FontWeight.w400,
                  //                       color: const Color.fromRGBO(
                  //                           255, 255, 255, 0.5),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  if (menus[menuIndex].translated!.description != null)
                    Text(
                      menus[menuIndex]
                          .translated!
                          .description!
                          .getStringName(context.localizations!.localeName),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(255, 255, 255, 0.75),
                      ),
                    ),
                  if (menus[menuIndex].amounts == null)
                    Text(
                      AppConstant.currencyFormat(
                          context.localizations!.localeName,
                          menus[menuIndex].price!),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                    ),
                  if (menus[menuIndex].amounts != null)
                    if (menus[menuIndex].amounts!.isEmpty)
                      Text(
                        AppConstant.currencyFormat(
                            context.localizations!.localeName,
                            menus[menuIndex].price!),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 0.5),
                        ),
                      ),
                  if (menus[menuIndex].amounts != null)
                    Column(
                      children: List.generate(
                        menus[menuIndex].amounts!.length,
                        (amountIndex) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${menus[menuIndex].amounts![amountIndex].amount} ${menus[menuIndex].amounts![amountIndex].unit} -- ${AppConstant.currencyFormat(context.localizations!.localeName, menus[menuIndex].amounts![amountIndex].unitPrice!)}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(255, 255, 255, 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:ui';
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
import 'package:qrmenu/core/utils/constants.dart';
import 'package:qrmenu/screens/widgets/full_screen_image_widget.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StyleThreeWidget extends StatefulWidget {
  final Restaurant restaurant;
  final List<MenuCategory> categories;
  final List<Menu> menus;
  final List<MenuTab> tabs;

  const StyleThreeWidget({
    super.key,
    required this.restaurant,
    required this.categories,
    required this.menus,
    required this.tabs,
  });

  @override
  State<StyleThreeWidget> createState() => _StyleThreeWidgetState();
}

class _StyleThreeWidgetState extends State<StyleThreeWidget>
    with SingleTickerProviderStateMixin {
  MenuCategory? selectedCategory;
  late Map<String, List<Menu>> menus;

  MenuTab? _selectedTab;
  late List<MenuCategory> categories;
  String _searchQuery = '';
  bool _showBackToTop = false;
  final Set<String> _selectedMenuItemIds = {};

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

    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.isNotEmpty) {
        int index = itemPositionsListener.itemPositions.value.first.index;
        setState(() {
          _showBackToTop = index > 0;
          if (index < categories.length) {
            selectedCategory = categories[index];
          }
        });
      }
    });

    scrollOffsetListener.changes.listen((event) {});
  }

  void setMenusByCategory() {
    menus = {};
    categories = [];

    if (widget.tabs.isNotEmpty) {
      _selectedTab ??= widget.tabs.first;

      for (MenuCategory category in widget.categories) {
        if (category.tab == _selectedTab?.en) {
          List<Menu> menusByCategory = [];
          for (Menu menu in widget.menus) {
            if (menu.category == category.id) {
              final menuName = menu.translated?.name
                      ?.getStringName(context.localizations!.localeName)
                      .toLowerCase() ??
                  '';
              final menuDesc = menu.translated?.description
                      ?.getStringName(context.localizations!.localeName)
                      .toLowerCase() ??
                  '';
              if (_searchQuery.isEmpty ||
                  menuName.contains(_searchQuery) ||
                  menuDesc.contains(_searchQuery)) {
                menusByCategory.add(menu);
              }
            }
          }
          if (menusByCategory.isNotEmpty || _searchQuery.isEmpty) {
            categories.add(category);
            menus[category.id!] = menusByCategory;
          }
        }
      }
    } else {
      for (MenuCategory category in widget.categories) {
        List<Menu> menusByCategory = [];
        for (Menu menu in widget.menus) {
          if (menu.category == category.id) {
            final menuName = menu.translated?.name
                    ?.getStringName(context.localizations!.localeName)
                    .toLowerCase() ??
                '';
            final menuDesc = menu.translated?.description
                    ?.getStringName(context.localizations!.localeName)
                    .toLowerCase() ??
                '';
            if (_searchQuery.isEmpty ||
                menuName.contains(_searchQuery) ||
                menuDesc.contains(_searchQuery)) {
              menusByCategory.add(menu);
            }
          }
        }
        if (menusByCategory.isNotEmpty || _searchQuery.isEmpty) {
          categories.add(category);
          menus[category.id!] = menusByCategory;
        }
      }
    }
  }

  void _showSelectedItemsPanel() {
    final List<Menu> selectedMenus =
        widget.menus.where((m) => _selectedMenuItemIds.contains(m.id)).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xEB230308),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border:
                Border(top: BorderSide(color: Color(0x35FFFFFF), width: 1.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.localizations?.localeName == 'tr'
                        ? 'Seçtikleriniz (Garsona Gösterin)'
                        : 'Your Choices (Show the Waiter)',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: selectedMenus.length,
                  itemBuilder: (context, idx) {
                    final item = selectedMenus[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x12FFFFFF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0x18FFFFFF)),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.translated!.name!.getStringName(
                                        context.localizations!.localeName),
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (item.price != null && item.price != 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        AppConstant.currencyFormat(
                                            context.localizations!.localeName,
                                            item.price!),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Color(0xFFE25B65), size: 22),
                              onPressed: () {
                                setState(() {
                                  _selectedMenuItemIds.remove(item.id);
                                });
                                Navigator.pop(context);
                                if (_selectedMenuItemIds.isNotEmpty) {
                                  _showSelectedItemsPanel();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    context.localizations?.localeName == 'tr'
                        ? 'MENÜYE DÖN'
                        : 'BACK TO MENU',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3B070F),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setMenusByCategory();

    if (selectedCategory == null && categories.isNotEmpty) {
      selectedCategory = categories.first;
    }

    return Consumer(builder: (context, ref, _) {
      return DefaultTabController(
        length: widget.tabs.isNotEmpty ? widget.tabs.length : 0,
        child: Scaffold(
          backgroundColor: const Color(0xFF3B070F),
          floatingActionButton: _showBackToTop
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFFD4AF37),
                  mini: true,
                  shape: const CircleBorder(),
                  onPressed: () {
                    itemScrollController.scrollTo(
                      index: 0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  },
                  child:
                      const Icon(Icons.arrow_upward, color: Color(0xFF3B070F)),
                )
              : null,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4D0A14),
                  Color(0xFF3B070F),
                  Color(0xFF230308),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Luxury Header with Logo & Language Dropdown
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo placement with premium font
                        Row(
                          children: [
                            if (widget.restaurant.restaurantLogo != null &&
                                widget.restaurant.restaurantLogo!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37),
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: const Color(0xFF230308),
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.restaurant.restaurantLogo!,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF230308),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    (widget.restaurant.name ?? 'R')
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: GoogleFonts.cormorantGaramond(
                                      color: const Color(0xFFD4AF37),
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.restaurant.name ?? 'Menu',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  height: 1.5,
                                  width: 45,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Premium Language Selection Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0x33FFFFFF),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: const Color(0x22FFFFFF)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Locale>(
                              dropdownColor: const Color(0xFF230308),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Color(0xFFD4AF37)),
                              value: Locale(context.localizations!.localeName),
                              items: AppLocalizations.supportedLocales.map((e) {
                                return DropdownMenuItem<Locale>(
                                  value: e,
                                  child: Text(
                                    AppConstant.getLocaleName(e.languageCode)
                                        .toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  ref
                                      .read(settingsBoxProvider)
                                      .put("language", v.languageCode);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu Tabs Navigation
                  if (widget.tabs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0x18FFFFFF),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          onTap: (i) {
                            _selectedTab = widget.tabs[i];
                            setMenusByCategory();
                            setState(() {});
                          },
                          labelStyle: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          unselectedLabelStyle: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                          indicator: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          labelColor: const Color(0xFF3B070F),
                          unselectedLabelColor: Colors.white60,
                          tabs: List.generate(
                            widget.tabs.length,
                            (index) => Tab(
                              text: widget.tabs[index]
                                  .getLacalName(
                                      context.localizations!.localeName)
                                  .toUpperCase(),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Search Box
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x15FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x1CFFFFFF)),
                      ),
                      child: TextField(
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 13),
                        cursorColor: const Color(0xFFD4AF37),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFFD4AF37), size: 18),
                          hintText:
                              "${context.localizations?.hello ?? 'Search'}...",
                          hintStyle: GoogleFonts.montserrat(
                              color: Colors.white38, fontSize: 13),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onChanged: (v) {
                          setState(() {
                            _searchQuery = v.trim().toLowerCase();
                            setMenusByCategory();
                          });
                        },
                      ),
                    ),
                  ),

                  // Glowing Animated Category Selection Slider
                  if (categories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: SizedBox(
                        height: 52,
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  selectedCategory?.id == categories[index].id;
                              return GestureDetector(
                                onTap: () {
                                  itemScrollController.scrollTo(
                                    index: index,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                  setState(() {
                                    selectedCategory = categories[index];
                                  });
                                },
                                child: AnimatedScale(
                                  scale: isSelected ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFD4AF37)
                                          : const Color(0x15FFFFFF),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFFFDF7A)
                                                .withOpacity(0.4)
                                            : const Color(0x22FFFFFF),
                                        width: 1.2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFD4AF37)
                                                    .withOpacity(0.4),
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 3),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (categories[index].categoryImage !=
                                                null &&
                                            categories[index]
                                                .categoryImage!
                                                .isNotEmpty)
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: isSelected
                                                ? const Color(0xFF3B070F)
                                                : Colors.transparent,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              categories[index].categoryImage!,
                                            ),
                                          ),
                                        if (categories[index].categoryImage !=
                                                null &&
                                            categories[index]
                                                .categoryImage!
                                                .isNotEmpty)
                                          const SizedBox(width: 8),
                                        Text(
                                          categories[index]
                                              .getLacalName(context
                                                  .localizations!.localeName)
                                              .toUpperCase(),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? const Color(0xFF3B070F)
                                                : Colors.white.withOpacity(0.9),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                  // Categorized Menu Items List
                  Expanded(
                    child: menus.isEmpty
                        ? Center(
                            child: Text(
                              context.localizations?.localeName == 'tr'
                                  ? 'Aranan ürün bulunamadı'
                                  : 'No items found',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white54, fontSize: 14),
                            ),
                          )
                        : ScrollablePositionedList.builder(
                            itemScrollController: itemScrollController,
                            itemCount: menus.length,
                            scrollOffsetController: scrollOffsetController,
                            itemPositionsListener: itemPositionsListener,
                            scrollOffsetListener: scrollOffsetListener,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              String key = menus.keys.toList()[index];
                              List<Menu> menuByCategory =
                                  menus.values.toList()[index];
                              menuByCategory
                                  .sort((a, b) => a.order.compareTo(b.order));

                              return CategoryItem(
                                category: getCategoryName(key),
                                menus: menuByCategory,
                                selectedIds: _selectedMenuItemIds,
                                onSelect: (id) {
                                  setState(() {
                                    if (_selectedMenuItemIds.contains(id)) {
                                      _selectedMenuItemIds.remove(id);
                                    } else {
                                      _selectedMenuItemIds.add(id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),

                  // Floating selection drawer at bottom
                  if (_selectedMenuItemIds.isNotEmpty)
                    GestureDetector(
                      onTap: _showSelectedItemsPanel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xCC3B070F),
                          border: const Border(
                              top: BorderSide(
                                  color: Color(0xFFD4AF37), width: 1.5)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, -5),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD4AF37)
                                        .withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xFFD4AF37),
                                        width: 1),
                                  ),
                                  child: const Icon(Icons.bookmark,
                                      color: Color(0xFFD4AF37), size: 20),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_selectedMenuItemIds.length} ${context.localizations?.localeName == 'tr' ? 'Seçilen Ürün' : 'Selected Items'}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      context.localizations?.localeName == 'tr'
                                          ? 'Garsona göstermek için tıklayın'
                                          : 'Tap to show the waiter',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white60,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                color: Color(0xFFD4AF37), size: 16),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  MenuCategory getCategoryName(String id) {
    for (MenuCategory category in widget.categories) {
      if (category.id == id) {
        return category;
      }
    }
    return widget.categories.first;
  }
}

class CategoryItem extends StatelessWidget {
  final MenuCategory category;
  final List<Menu> menus;
  final Set<String> selectedIds;
  final Function(String) onSelect;

  const CategoryItem({
    super.key,
    required this.category,
    required this.menus,
    required this.selectedIds,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        // Premium Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 18,
                    width: 3.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category
                          .getLacalName(context.localizations!.localeName)
                          .toUpperCase(),
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              if (category.translated?.description != null &&
                  category.translated!.description!
                      .getStringName(context.localizations!.localeName)
                      .isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    category.translated!.description!
                        .getStringName(context.localizations!.localeName),
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Container(
                height: 0.5,
                color: const Color(0x33FFFFFF),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(
            menus.length,
            (menuIndex) => MenuItemWidget(
              menu: menus[menuIndex],
              categoryId: category.id!,
              menuIndex: menuIndex,
              isSelected: selectedIds.contains(menus[menuIndex].id),
              onSelect: () => onSelect(menus[menuIndex].id!),
            ),
          ),
        ),
      ],
    );
  }
}

// Shimmer Effect Overlay Widget
class ShimmerWidget extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0x18FFFFFF),
                  Color(0x35FFFFFF),
                  Color(0x18FFFFFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  _shimmerController.value - 0.3,
                  _shimmerController.value,
                  _shimmerController.value + 0.3,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Live Glassmorphic Animated Product Card Widget
class MenuItemWidget extends StatefulWidget {
  final Menu menu;
  final String categoryId;
  final int menuIndex;
  final bool isSelected;
  final VoidCallback onSelect;

  const MenuItemWidget({
    super.key,
    required this.menu,
    required this.categoryId,
    required this.menuIndex,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    Future.delayed(
        Duration(milliseconds: (widget.menuIndex * 70).clamp(0, 700)), () {
      if (mounted) {
        _entryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Unique tags for Chef Choice / Popular / New
    final bool isChefChoice = widget.menu.id.hashCode % 5 == 0;
    final bool isPopular = widget.menu.id.hashCode % 3 == 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeInOut,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _isPressed
                          ? const Color(0x25FFFFFF)
                          : const Color(0x14FFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isPressed
                            ? const Color(0x40FFFFFF)
                            : widget.isSelected
                                ? const Color(0xFFD4AF37).withOpacity(0.5)
                                : const Color(0x18FFFFFF),
                        width: widget.isSelected ? 1.5 : 1.2,
                      ),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color:
                                    const Color(0xFFD4AF37).withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Image with Shimmer placeholder
                        if (widget.menu.menuImage != null &&
                            widget.menu.menuImage!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: FullScreenWidget(
                              disposeLevel: DisposeLevel.Low,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Hero(
                                  tag:
                                      "${widget.categoryId}_${widget.menu.id}_${widget.menuIndex}",
                                  child: CachedNetworkImage(
                                    imageUrl: widget.menu.menuImage!.first,
                                    height: 95,
                                    width: 95,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const ShimmerWidget(
                                      height: 95,
                                      width: 95,
                                      borderRadius: 14,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 95,
                                      width: 95,
                                      color: const Color(0x11FFFFFF),
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.white24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: Container(
                              height: 95,
                              width: 95,
                              decoration: BoxDecoration(
                                color: const Color(0x11FFFFFF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.white.withOpacity(0.3),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),

                        // Details Column
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 95),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Special Glowing Badges for visual delight
                                    if (isChefChoice || isPopular)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isChefChoice
                                                ? const Color(0xFFD4AF37)
                                                    .withOpacity(0.2)
                                                : const Color(0xFFE25B65)
                                                    .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isChefChoice
                                                  ? const Color(0xFFD4AF37)
                                                      .withOpacity(0.4)
                                                  : const Color(0xFFE25B65)
                                                      .withOpacity(0.4),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Text(
                                            isChefChoice
                                                ? (context.localizations
                                                            ?.localeName ==
                                                        'tr'
                                                    ? 'ŞEFIN SEÇIMI'
                                                    : "CHEF'S CHOICE")
                                                : (context.localizations
                                                            ?.localeName ==
                                                        'tr'
                                                    ? 'POPÜLER'
                                                    : 'POPULAR'),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: isChefChoice
                                                  ? const Color(0xFFD4AF37)
                                                  : const Color(0xFFE25B65),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.menu.translated!.name!
                                                .getStringName(context
                                                    .localizations!.localeName),
                                            style:
                                                GoogleFonts.cormorantGaramond(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        if (widget.menu.price != null &&
                                            widget.menu.price != 0)
                                          Text(
                                            AppConstant.currencyFormat(
                                              context.localizations!.localeName,
                                              widget.menu.price!,
                                            ),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFD4AF37),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (widget.menu.translated!.description !=
                                            null &&
                                        widget.menu.translated!.description!
                                            .getStringName(context
                                                .localizations!.localeName)
                                            .isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          widget.menu.translated!.description!
                                              .getStringName(context
                                                  .localizations!.localeName),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Colors.white.withOpacity(0.65),
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Multi amount prices or allergens list + Add to collection button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: widget.menu.amounts != null &&
                                              widget.menu.amounts!.isNotEmpty
                                          ? Wrap(
                                              spacing: 6.0,
                                              runSpacing: 4.0,
                                              children: List.generate(
                                                widget.menu.amounts!.length,
                                                (amtIdx) => Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x18FFFFFF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    '${widget.menu.amounts![amtIdx].amount} ${widget.menu.amounts![amtIdx].unit} - ${AppConstant.currencyFormat(context.localizations!.localeName, widget.menu.amounts![amtIdx].unitPrice!)}',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white
                                                          .withOpacity(0.85),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : widget.menu.allergens != null &&
                                                  widget.menu.allergens!
                                                      .isNotEmpty
                                              ? Text(
                                                  '${context.localizations?.error ?? "Allergens"}: ${widget.menu.allergens!.join(', ')}',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                        .withOpacity(0.45),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        widget.isSelected
                                            ? Icons.check_circle
                                            : Icons.add_circle_outline,
                                        color: widget.isSelected
                                            ? const Color(0xFFD4AF37)
                                            : Colors.white60,
                                        size: 24,
                                      ),
                                      onPressed: widget.onSelect,
                                    )
                                  ],
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
            ),
          ),
        ),
      ),
    );
  }
}

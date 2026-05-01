import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/global_providers/user_state_provider.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/amount.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/models/menu/translate_values.dart';
import 'package:qrmenu/core/models/menu/translated_values.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/core/utils/constants.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';
import 'package:qrmenu/screens/dashboard_screen/riverpods/restaurant_menus_provider.dart';
import 'package:qrmenu/screens/new_menu_screen/widgets/add_amount_dialog_widget.dart';

import 'widgets/add_ingredient_dialog_widget.dart';
import 'widgets/menu_item_detail_widget.dart';

class AddMenuItemScreen extends ConsumerStatefulWidget {
  static String routeName = "/new-menu";
  final Menu? menu;
  const AddMenuItemScreen({super.key, this.menu});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends ConsumerState<AddMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController orderCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode descFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();
  List<String> ingredient = [];
  List<String> allergens = [];
  List<Amount> amounts = [];

  MenuCategory? selectedCategory;

  bool isNew = true;
  bool isVeg = false;
  bool isSpicy = false;
  bool isJain = false;
  bool isSpecial = false;
  bool isSweet = false;
  bool isPopular = false;

  bool isBussy = false;

  List<File> menuItemFiles = [];
  List<String> itemImageFiles = [];
  TranslatedValues _translatedValues = TranslatedValues();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.menu != null) {
      nameCont.text = widget.menu!.translateValues!.name.toString();
      priceCont.text = widget.menu!.price.toString();
      descCont.text = widget.menu!.description.toString();
      if (widget.menu?.ingredient != null) {
        ingredient = widget.menu!.ingredient!;
      }
      if (widget.menu?.allergens != null) {
        allergens = widget.menu!.allergens!;
      }

      if (widget.menu?.isNew != null) isNew = widget.menu!.isNew!;
      if (widget.menu?.isVeg != null) isVeg = widget.menu!.isVeg!;
      if (widget.menu?.isSpicy != null) isSpicy = widget.menu!.isSpicy!;
      if (widget.menu?.isJain != null) isJain = widget.menu!.isJain!;
      if (widget.menu?.isSpecial != null) isSpecial = widget.menu!.isSpecial!;
      if (widget.menu?.isSweet != null) isSweet = widget.menu!.isSweet!;
      if (widget.menu?.isPopular != null) isPopular = widget.menu!.isPopular!;
      if (widget.menu?.menuImage != null) {
        itemImageFiles = widget.menu!.menuImage!;
      }
      if (widget.menu?.category != null) {
        selectedCategory = ref
            .read(categoriesProvider.notifier)
            .getCategoryById(widget.menu?.category);
      }
      if (widget.menu?.order != null) {
        orderCont.text = widget.menu!.order.toString();
      }
      if (widget.menu?.amounts != null) {
        amounts = widget.menu!.amounts!;
      }
      if (widget.menu?.translated != null) {
        _translatedValues = widget.menu!.translated!;
      }

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        context.localizations!.addMenuItem,
        actions: [
          if (widget.menu?.id != null)
            IconButton(
              onPressed: () {
                showConfirmDialogCustom(context, onAccept: (c) async {
                  await ref
                      .read(restaurantMenusProvider.notifier)
                      .delete(widget.menu!.id!);
                  // ignore: use_build_context_synchronously
                  context.pop();
                },
                    dialogType: DialogType.DELETE,
                    title: context.localizations!.doYouWantToDelete(
                        widget.menu!.translateValues!.name!));
              },
              icon: Icon(Icons.delete, color: context.iconColor),
            ),
        ],
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        showBack: Navigator.canPop(context) ? true : false,
      ),
      body: Consumer(builder: (context, ref, _) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1, color: context.dividerColor),
                      16.height,
                      Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: boxDecorationWithShadow(
                            blurRadius: 0,
                            borderRadius: radius(8),
                            backgroundColor: context.cardColor),
                        child: Column(
                          children: [
                            Icon(Icons.add, size: 28, color: context.iconColor),
                            Text(context.localizations!.chooseMenuItemImages,
                                style: secondaryTextStyle()),
                          ],
                        ),
                      ).onTap(() async {
                        File image = await getImageSource();
                        menuItemFiles.add(image);

                        setState(() {});
                      }),
                      8.height,
                      Text(context.localizations!.selectImgNote,
                          style:
                              secondaryTextStyle(size: 8, color: Colors.red)),
                      16.height,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (menuItemFiles.isNotEmpty)
                              HorizontalList(
                                  itemCount: menuItemFiles.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        if (kIsWeb)
                                          Image.network(menuItemFiles[i].path,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover),
                                        if (!kIsWeb)
                                          Image.file(menuItemFiles[i],
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover)
                                              .cornerRadiusWithClipRRect(6),
                                        const Icon(Icons.delete, color: white)
                                            .onTap(() {
                                          menuItemFiles.removeAt(i);
                                          setState(() {});
                                        }),
                                      ],
                                    );
                                  }).paddingBottom(16),
                            if (itemImageFiles.isNotEmpty)
                              HorizontalList(
                                  itemCount: itemImageFiles.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        cachedImage(
                                                itemImageFiles[i].validate(),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover)
                                            .cornerRadiusWithClipRRect(6),
                                        const Icon(Icons.delete, color: white)
                                            .onTap(() async {
                                          String imageUrl = itemImageFiles[i];

                                          itemImageFiles.removeAt(i);
                                          await ref
                                              .read(restaurantMenusProvider
                                                  .notifier)
                                              .removeMenuImage(widget.menu!.id!,
                                                  imageUrl, itemImageFiles);

                                          setState(() {});
                                        }),
                                      ],
                                    );
                                  }).paddingBottom(16),
                          ],
                        ),
                      ),
                      16.height,
                      Container(
                        decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: radius(defaultRadius)),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.localizations!.enterFoodItemDetails,
                                style: boldTextStyle()),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              focus: nameFocus,
                              nextFocus: categoryFocus,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecoration(
                                context,
                                label: context.localizations!.name,
                                textStyle: secondaryTextStyle(
                                    color: AppPalette.bodyColor),
                              ).copyWith(
                                prefixIcon: Image.asset(
                                        'assets/images/ic_Draft.png',
                                        height: 16,
                                        width: 16,
                                        fit: BoxFit.cover,
                                        color: AppPalette.bodyColor)
                                    .paddingAll(12),
                              ),
                              controller: nameCont,
                              textFieldType: TextFieldType.NAME,
                            ),
                            16.height,
                            if (widget.menu?.id != null)
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    AppTextField(
                                      initialValue: _translatedValues.name?.de,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "de",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.name?.de = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue: _translatedValues.name?.en,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "en",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.name?.en = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue: _translatedValues.name?.nl,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "nl",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.name?.nl = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue: _translatedValues.name?.fr,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "fr",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.name?.fr = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue: _translatedValues.name?.tr,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "tr",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.name?.tr = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.menu?.id != null) 16.height,
                            DropdownButtonFormField<MenuCategory>(
                              onChanged: (value) {
                                selectedCategory = value;
                              },
                              value: selectedCategory,
                              isExpanded: true,
                              validator: null,
                              decoration: inputDecoration(context,
                                      label:
                                          context.localizations!.chooseCategory)
                                  .copyWith(
                                prefixIcon: Image.asset(
                                        'assets/images/ic_Category.png',
                                        height: 12,
                                        width: 12,
                                        fit: BoxFit.cover,
                                        color: AppPalette.bodyColor)
                                    .paddingAll(12),
                              ),
                              dropdownColor: context.cardColor,
                              alignment: Alignment.bottomCenter,
                              items: List.generate(
                                ref.watch(categoriesProvider).length,
                                (index) {
                                  MenuCategory data =
                                      ref.read(categoriesProvider)[index];
                                  return DropdownMenuItem(
                                    value: data,
                                    child: Text(
                                        data.translated!.name!.getStringName(
                                            context.localizations!.localeName),
                                        style: primaryTextStyle()),
                                  );
                                },
                              ),
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              inputFormatters: <TextInputFormatter>[
                                AppConstant.doubleRegExp
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              focus: priceFocus,
                              nextFocus: descFocus,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecoration(
                                context,
                                label: context.localizations!.price,
                                textStyle: secondaryTextStyle(
                                    color: AppPalette.bodyColor),
                              ).copyWith(
                                prefixIcon: IconButton(
                                  icon: Text("€",
                                      style: secondaryTextStyle(
                                          size: 24,
                                          color: AppPalette.bodyColor)),
                                  onPressed: () {},
                                ),
                              ),
                              controller: priceCont,
                              textFieldType: TextFieldType.PHONE,
                            ),
                            16.height,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              width: context.width(),
                              decoration: commonDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_Notebook.png',
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            color: AppPalette.bodyColor,
                                          ).paddingAll(8),
                                          8.width,
                                          Text(
                                              context
                                                  .localizations!.ingredients,
                                              style: secondaryTextStyle(
                                                  color: AppPalette.bodyColor)),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: AppPalette.bodyColor),
                                        onPressed: () async {
                                          String? newIngredient =
                                              await showInDialog(
                                            context,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            builder: (c) {
                                              return AddIngredientDialogComponent(
                                                title: context.localizations!
                                                    .addIngredient,
                                              );
                                            },
                                          );

                                          if (newIngredient != null) {
                                            ingredient.add(newIngredient);
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 16,
                                    runSpacing: 16,
                                    runAlignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: List.generate(
                                      ingredient.length,
                                      (index) => Chip(
                                        labelStyle: primaryTextStyle(size: 16),
                                        label: Text(ingredient[index]
                                            .capitalizeFirstLetter()),
                                        deleteIcon: const Icon(Icons.clear,
                                            color: Colors.red, size: 20),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: context.cardColor,
                                        onDeleted: () {
                                          ingredient.removeAt(index);
                                          setState(() {});
                                        },
                                      ).onTap(() async {
                                        String? newIngredient =
                                            await showInDialog(
                                          context,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          builder: (c) {
                                            return AddIngredientDialogComponent(
                                              value: ingredient[index],
                                              title: context
                                                  .localizations!.addIngredient,
                                            );
                                          },
                                        );

                                        if (newIngredient != null) {
                                          ingredient[index] = newIngredient;

                                          setState(() {});
                                        }
                                        if (mounted) hideKeyboard(context);
                                      }, borderRadius: radius(80)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.height,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              width: context.width(),
                              decoration: commonDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_Notebook.png',
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            color: AppPalette.bodyColor,
                                          ).paddingAll(8),
                                          8.width,
                                          Text(context.localizations!.allergens,
                                              style: secondaryTextStyle(
                                                  color: AppPalette.bodyColor)),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: AppPalette.bodyColor),
                                        onPressed: () async {
                                          String? allergen = await showInDialog(
                                            context,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            builder: (c) {
                                              return AddIngredientDialogComponent(
                                                title: context
                                                    .localizations!.addAllergen,
                                              );
                                            },
                                          );

                                          if (allergen != null) {
                                            allergens.add(allergen);
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 16,
                                    runSpacing: 16,
                                    runAlignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: List.generate(
                                      allergens.length,
                                      (index) => Chip(
                                        labelStyle: primaryTextStyle(size: 16),
                                        label: Text(allergens[index]
                                            .capitalizeFirstLetter()),
                                        deleteIcon: const Icon(Icons.clear,
                                            color: Colors.red, size: 20),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: context.cardColor,
                                        onDeleted: () {
                                          allergens.removeAt(index);
                                          setState(() {});
                                        },
                                      ).onTap(() async {
                                        String? allergen = await showInDialog(
                                          context,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          builder: (c) {
                                            return AddIngredientDialogComponent(
                                              value: allergens[index],
                                              title: context
                                                  .localizations!.addAllergen,
                                            );
                                          },
                                        );

                                        if (allergen != null) {
                                          allergens[index] = allergen;

                                          setState(() {});
                                        }
                                        if (mounted) hideKeyboard(context);
                                      }, borderRadius: radius(80)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.height,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              width: context.width(),
                              decoration: commonDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_Notebook.png',
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            color: AppPalette.bodyColor,
                                          ).paddingAll(8),
                                          8.width,
                                          Text("Amounts",
                                              style: secondaryTextStyle(
                                                  color: AppPalette.bodyColor)),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: AppPalette.bodyColor),
                                        onPressed: () async {
                                          Amount? newAmount =
                                              await showInDialog(
                                            context,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            builder: (c) {
                                              return const AddAmountDialogComponent();
                                            },
                                          );

                                          if (newAmount != null) {
                                            amounts.add(newAmount);
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 16,
                                    runSpacing: 16,
                                    runAlignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: List.generate(
                                      amounts.length,
                                      (index) => Chip(
                                        labelStyle: primaryTextStyle(size: 16),
                                        label: Text(
                                            "${amounts[index].amount}-${amounts[index].unitPrice}"),
                                        deleteIcon: const Icon(Icons.clear,
                                            color: Colors.red, size: 20),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: context.cardColor,
                                        onDeleted: () {
                                          amounts.removeAt(index);
                                          setState(() {});
                                        },
                                      ).onTap(() async {
                                        Amount? newAmaunt = await showInDialog(
                                          context,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          builder: (c) {
                                            return AddAmountDialogComponent(
                                              amount: amounts[index].amount,
                                              price: amounts[index].unitPrice,
                                              unit: amounts[index].unit,
                                            );
                                          },
                                        );

                                        if (newAmaunt != null) {
                                          amounts[index] = newAmaunt;

                                          setState(() {});
                                        }
                                        if (mounted) hideKeyboard(context);
                                      }, borderRadius: radius(80)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              focus: descFocus,
                              textInputAction: TextInputAction.done,
                              decoration: inputDecoration(
                                context,
                                label: context.localizations!.description,
                                textStyle: secondaryTextStyle(
                                    color: AppPalette.bodyColor),
                              ).copyWith(
                                prefixIcon: Image.asset(
                                        'assets/images/ic_Draft.png',
                                        height: 16,
                                        width: 16,
                                        fit: BoxFit.cover,
                                        color: AppPalette.bodyColor)
                                    .paddingAll(12),
                              ),
                              controller: descCont,
                              minLines: 3,
                              maxLines: 3,
                              textFieldType: TextFieldType.MULTILINE,
                            ),
                            16.height,
                            if (widget.menu?.id != null)
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    AppTextField(
                                      initialValue:
                                          _translatedValues.description?.de,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "de",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.description?.de = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue:
                                          _translatedValues.description?.en,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "en",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.description?.en = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue:
                                          _translatedValues.description?.nl,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "nl",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.description?.nl = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue:
                                          _translatedValues.description?.fr,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "fr",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.description?.fr = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                    16.height,
                                    AppTextField(
                                      initialValue:
                                          _translatedValues.description?.tr,
                                      textStyle: primaryTextStyle(),
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration(
                                        context,
                                        label: "tr",
                                        textStyle: secondaryTextStyle(
                                            color: AppPalette.bodyColor),
                                      ).copyWith(
                                        prefixIcon: Image.asset(
                                                'assets/images/ic_Draft.png',
                                                height: 16,
                                                width: 16,
                                                fit: BoxFit.cover,
                                                color: AppPalette.bodyColor)
                                            .paddingAll(12),
                                      ),
                                      onChanged: (v) {
                                        _translatedValues.description?.tr = v;
                                      },
                                      textFieldType: TextFieldType.NAME,
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.menu?.id != null) 16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              textInputAction: TextInputAction.done,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: inputDecoration(
                                context,
                                label: context.localizations!.order,
                                textStyle: secondaryTextStyle(
                                    color: AppPalette.bodyColor),
                              ).copyWith(
                                prefixIcon: Image.asset(
                                        'assets/images/ic_Draft.png',
                                        height: 16,
                                        width: 16,
                                        fit: BoxFit.cover,
                                        color: AppPalette.bodyColor)
                                    .paddingAll(12),
                              ),
                              controller: orderCont,
                              textFieldType: TextFieldType.NUMBER,
                            ),
                            16.height,
                          ],
                        ),
                      ),
                      16.height,
                      Container(
                        decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: radius(defaultRadius)),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.localizations!.otherDetailsToAdd,
                                style: boldTextStyle()),
                            8.height,
                            MenuItemDetailComponent(
                              title: context.localizations!.newKey,
                              subtitle: context.localizations!.newDescription,
                              isSelected: isNew,
                              onChanged: (val) {
                                isNew = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: context.localizations!.veg,
                              subtitle: context.localizations!.vegDescription,
                              isSelected: isVeg,
                              onChanged: (bool val) {
                                isVeg = val;

                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: context.localizations!.spicy,
                              subtitle: context.localizations!.spicyDescription,
                              isSelected: isSpicy,
                              onChanged: (val) {
                                isSpicy = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: context.localizations!.jain,
                              subtitle: context.localizations!.jainDescription,
                              isSelected: isJain,
                              onChanged: (val) {
                                isJain = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: context.localizations!.special,
                              subtitle:
                                  context.localizations!.specialDescription,
                              isSelected: isSpecial,
                              onChanged: (val) {
                                isSpecial = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: context.localizations!.sweet,
                              subtitle: context.localizations!.sweetDescription,
                              isSelected: isSweet,
                              onChanged: (val) {
                                isSweet = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: context.localizations!.popular,
                              subtitle:
                                  context.localizations!.popularDescription,
                              isSelected: isPopular,
                              onChanged: (val) {
                                isPopular = val;
                                setState(() {});
                              },
                            ),
                          ],
                        ).center(),
                      ),
                    ],
                  ),
                ),
              ).center(),
            ).visible(!isBussy, defaultWidget: Loader()),
          ],
        );
      }),
      bottomNavigationBar: AppButton(
        text: context.localizations!.save.toUpperCase(),
        textStyle: boldTextStyle(color: Colors.white, size: 18),
        margin: const EdgeInsets.all(16),
        elevation: 0,
        color: AppPalette.primaryColor,
        enabled: isBussy ? false : true,
        shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
        onTap: () {
          saveData();
        },
      ).visible(true),
    );
  }

  Future<void> saveData() async {
    if (selectedCategory == null) {
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(context.localizations!.pleaseSelectACategory),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
      return;
    }

    if (priceCont.text.isEmpty) {
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(context.localizations!.pleaseSpecifyAValidPrice),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
      return;
    }

    if (orderCont.text.isEmpty) {
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(context.localizations!.missingInformation),
          content: Text(context.localizations!.orderIsReqiered),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
      return;
    }

    setState(() {
      isBussy = true;
    });

    List<String> imagePaths = itemImageFiles;
    for (File file in menuItemFiles) {
      imagePaths.add(file.path);
    }

    late String category;

    if (selectedCategory == null) {
      category = "Uncategorized";
    } else {
      category = selectedCategory!.id!;
    }

    Menu menu = Menu(
        id: widget.menu?.id,
        restaurantId: ref.read(authStateProvider)!.uid,
        price: double.parse(priceCont.text),
        description: descCont.text,
        category: category,
        isJain: isJain,
        isNew: isNew,
        isVeg: isVeg,
        isPopular: isPopular,
        isSpecial: isSpecial,
        isSpicy: isSpicy,
        isSweet: isSweet,
        ingredient: ingredient,
        menuImage: imagePaths,
        order: int.parse(orderCont.text),
        amounts: amounts,
        translateValues:
            TranslateValues(name: nameCont.text, description: descCont.text),
        translated: _translatedValues,
        allergens: allergens);

    if (widget.menu?.id != null) {
      await ref.read(restaurantMenusProvider.notifier).updateMenu(menu);
    } else {
      await ref.read(restaurantMenusProvider.notifier).saveNewMenu(menu);
    }

    setState(() {
      isBussy = false;
    });

    if (mounted) {
      showConfirmDialogCustom(context, onAccept: (c) {
        context.pop();
      },
          dialogType: DialogType.CONFIRMATION,
          title: context.localizations!.theMenuHasBeenSavedSuccessfully,
          positiveText: 'Go Back');
    }
  }

  BoxDecoration commonDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(width: 1, color: context.dividerColor));
  }
}

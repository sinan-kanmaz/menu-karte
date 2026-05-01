import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/global_providers/user_state_provider.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/category/translate_values.dart';
import 'package:qrmenu/core/models/category/translated_values.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/repositories/firestore_repository.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';

import 'widgets/image_option_widget.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  static String routeName = "/new-category";
  final MenuCategory? category;

  const AddCategoryScreen({super.key, this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  File? image;
  String? categoryImage = '';
  String? defaultImage = '';
  MenuTab? tab;

  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController orderCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descFocus = FocusNode();
  TranslatedValues _translatedValues = TranslatedValues();

  bool _isBussy = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      nameCont.text = widget.category!.translateValues!.name!;
      descCont.text = widget.category!.translateValues!.description!;
      orderCont.text = widget.category!.order.toString();
      defaultImage = widget.category?.categoryImage;

      if (widget.category?.translated != null) {
        _translatedValues = widget.category!.translated!;
      }
      if (widget.category?.tab != null) {
        ref.read(userStateProvider)?.menuTabs?.forEach((element) {
          if (element.en == widget.category?.tab) {
            tab = element;
          }
        });
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);

    if (_isBussy) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (user == null) {
      ref
          .read(userStateProvider.notifier)
          .getRestauarnt(ref.read(authStateProvider)!.uid);
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return Scaffold(
      appBar: appBarWidget(
        context.localizations!.addCategory,
        actions: [
          if (widget.category != null)
            IconButton(
              icon: Icon(Icons.delete, color: context.iconColor),
              onPressed: () {
                showConfirmDialogCustom(
                  context,
                  onAccept: (c) {
                    ref
                        .read(firestoreRepositoryProvider)
                        .deleteCategory(widget.category!);
                  },
                  dialogType: DialogType.DELETE,
                  title: context.localizations!.doYouWantToDelete(
                      widget.category!.translateValues!.name!),
                );
              },
            ).visible(true),
        ],
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Divider(thickness: 1, color: context.dividerColor),
                    16.height,
                    ImageOptionComponent(
                      isRes: false,
                      defaultImage: defaultImage,
                      name: context.localizations!.addImage,
                      onImageSelected: (File? value) async {
                        image = value;
                        categoryImage = value!.path;
                        setState(() {});
                      },
                    )
                        .center()
                        .withSize(width: context.width() - 32, height: 230),
                    32.height,
                    Container(
                      decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: radius(defaultRadius)),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.localizations!.enterCategoryDetails,
                              style: boldTextStyle()),
                          18.height,
                          AppTextField(
                            controller: nameCont,
                            textFieldType: TextFieldType.NAME,
                            textStyle: primaryTextStyle(),
                            focus: nameFocus,
                            nextFocus: descFocus,
                            decoration: inputDecoration(
                              context,
                              label: context.localizations!.categoryName,
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
                          ),
                          18.height,
                          if (widget.category?.id != null)
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
                          if (widget.category?.id != null) 18.height,
                          AppTextField(
                            controller: descCont,
                            buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    maxLength}) =>
                                null,
                            maxLines: 8,
                            minLines: 3,
                            textFieldType: TextFieldType.MULTILINE,
                            focus: descFocus,
                            textStyle: primaryTextStyle(),
                            textInputAction: TextInputAction.done,
                            decoration: inputDecoration(
                              context,
                              label: context.localizations!.categoryDescription,
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
                          ),
                          18.height,
                          if (widget.category?.id != null)
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
                          if (widget.category?.id != null) 16.height,
                          AppTextField(
                            controller: orderCont,
                            textFieldType: TextFieldType.NUMBER,
                            textStyle: primaryTextStyle(),
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
                          ),
                          if (user.menuTabs != null)
                            if (user.menuTabs!.isNotEmpty)
                              DropdownButton<MenuTab>(
                                isExpanded: true,
                                hint: Text(
                                    context.localizations!.pleaseSelectaTab),
                                value: tab,
                                items: List.generate(
                                  user.menuTabs!.length,
                                  (index) => DropdownMenuItem(
                                    value: user.menuTabs![index],
                                    child: Text(
                                      user.menuTabs![index].getLacalName(
                                          context.localizations!.localeName),
                                      style: primaryTextStyle(),
                                    ),
                                  ),
                                ),
                                onChanged: (v) {
                                  tab = v;
                                  setState(() {});
                                },
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).center(),
          ),
          Loader().center().visible(false),
        ],
      ),
      bottomNavigationBar: AppButton(
        text: context.localizations!.save,
        textStyle: boldTextStyle(color: Colors.white, size: 18),
        margin: const EdgeInsets.all(16),
        elevation: 0,
        color: AppPalette.primaryColor,
        enabled: true,
        shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
        onTap: () {
          if (orderCont.text.isEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: Text(context.localizations!.missingInformation),
                content: Text(context.localizations!.orderIsReqiered),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ],
              ),
            );

            return;
          }

          setState(() {
            _isBussy = true;
          });

          MenuCategory category = MenuCategory(
            id: widget.category?.id,
            translateValues: TranslateValues(
              name: nameCont.text,
              description: descCont.text,
            ),
            categoryImage: image?.path,
            tab: tab?.en,
            order: int.parse(orderCont.text),
          );

          if (widget.category?.id == null) {
            ref
                .read(categoriesProvider.notifier)
                .saveNewCategory(category)
                .then((value) {
              setState(() {
                _isBussy = false;
              });
              showConfirmDialogCustom(
                context,
                cancelable: false,
                dialogType: DialogType.ACCEPT,
                title: 'Added ${nameCont.text}',
                onAccept: (context) {
                  hideKeyboard(context);
                  context.pop();
                  context.pop();
                },
              );
            });
          } else {
            ref
                .read(categoriesProvider.notifier)
                .updateCategory(category)
                .then((value) {
              setState(() {
                _isBussy = false;
              });
              showConfirmDialogCustom(
                context,
                cancelable: false,
                dialogType: DialogType.ACCEPT,
                title: 'Added ${nameCont.text}',
                onAccept: (context) {
                  hideKeyboard(context);
                  context.pop();
                  context.pop();
                },
              );
            });
          }
        },
      ).visible(true),
    );
  }
}

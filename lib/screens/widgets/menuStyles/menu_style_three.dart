import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/screens/dashboard_screen/widgets/veg_widget.dart';
import 'package:qrmenu/screens/widgets/menuStyles/user_add_item_widget.dart';

// ignore: must_be_immutable
class MenuComponentStyleThree extends StatelessWidget {
  final Menu? menuData;
  final bool isLast;
  final VoidCallback? callback;

  const MenuComponentStyleThree({
    super.key,
    this.menuData,
    this.callback,
    required this.isLast,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: radius(defaultRadius),
          color: context.scaffoldBackgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      menuData!.isVeg.validate()
                          ? const VegComponent(size: 18)
                          : const NonVegComponent(size: 18),
                      10.width,
                      if (menuData!.isNew.validate())
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppPalette.primaryColor.withAlpha(30),
                              borderRadius: radius(defaultRadius)),
                          child: Text(
                            context.localizations!.newKey,
                            style: boldTextStyle(
                                size: 12, color: AppPalette.primaryColor),
                          ),
                        ).cornerRadiusWithClipRRect(2),
                    ],
                  ),
                  8.height,
                  Text(menuData!.translateValues!.name!.trim(),
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ).expand(),
              if (menuData!.menuImage != null)
                if (menuData!.menuImage!.isNotEmpty)
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.dividerColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: cachedImage(menuData!.menuImage!.first.validate(),
                          fit: BoxFit.cover),
                    ),
                  ),
            ],
          ),
          8.height,
          Divider(thickness: 1, color: context.dividerColor),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              priceWidget(
                  currency: '€',
                  price: '${menuData!.price.validate()}',
                  style: boldTextStyle(color: AppPalette.primaryColor)),
              // UserAddItemComponent(
              //   menuData: menuData,
              //   quantity: quantity,
              //   callback: () {
              //     callback?.call();
              //   },
              // ),
            ],
          ),
        ],
      ),
    ).onTap(() async {
      callback?.call();

      // if (isAdmin) {
      // bool? res = await push(
      //     AddMenuItemScreen(data: data, menuData: menuData),
      //     pageRouteAnimation: PageRouteAnimation.Scale,
      //     duration: 450.milliseconds);
      // if (res ?? false) {
      //   callback?.call();
      // }
      // }
    }, borderRadius: radius(6)).paddingSymmetric(horizontal: 16, vertical: 8);
  }
}

class SampleMenuThree extends StatelessWidget {
  const SampleMenuThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? context.width() / 2 : context.width() / 1,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: radius(defaultRadius),
          color: context.scaffoldBackgroundColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const VegComponent(size: 18),
                      10.width,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppPalette.primaryColor.withAlpha(30),
                            borderRadius: radius(defaultRadius)),
                        child: Text(context.localizations!.newKey,
                            style: boldTextStyle(
                                size: 12, color: AppPalette.primaryColor)),
                      ).cornerRadiusWithClipRRect(2),
                    ],
                  ),
                  8.height,
                  Text('Italian Pizza',
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ).expand(),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.dividerColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('images/pizza.jpg', fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          8.height,
          Divider(thickness: 1, color: context.dividerColor),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              priceWidget(
                  currency: '\$',
                  price: '25.55',
                  style: boldTextStyle(color: AppPalette.primaryColor)),
              const SampleAddButton(),
            ],
          ),
        ],
      ),
    );
  }
}

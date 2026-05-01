import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/screens/dashboard_screen/widgets/veg_widget.dart';
import 'package:qrmenu/screens/widgets/menuStyles/user_add_item_widget.dart';

// ignore: must_be_immutable
class MenuComponentStyleTwo extends StatelessWidget {
  final Menu? menuData;
  final VoidCallback? callback;
  final bool? isTablet;
  final bool? isWeb;

  const MenuComponentStyleTwo(
      {super.key, this.menuData, this.callback, this.isWeb, this.isTablet});

  @override
  Widget build(BuildContext context) {
    double getWidth() {
      if (isTablet.validate()) {
        return context.width() / 2;
      } else if (isWeb.validate()) {
        return context.width() / 4;
      }
      return context.width() / 1;
    }

    return Container(
      width: getWidth(),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: radius(defaultRadius),
          color: context.scaffoldBackgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(context.localizations!.newKey,
                          style: boldTextStyle(
                              size: 12, color: AppPalette.primaryColor)),
                    ).cornerRadiusWithClipRRect(2),
                ],
              ),
              priceWidget(
                  currency: '€',
                  price: '${menuData!.price.validate()}',
                  style: boldTextStyle(color: AppPalette.primaryColor)),
            ],
          ),
          8.height,
          Text(menuData!.translateValues!.name!.trim(),
              style: boldTextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          8.height,
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Divider(thickness: 1, color: context.dividerColor),
          //     8.height,
          //     UserAddItemComponent(
          //       menuData: menuData,
          //       quantity: quantity,
          //       callback: () {
          //         callback?.call();
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    ).onTap(() async {
      callback?.call();
    }, borderRadius: radius(6)).paddingSymmetric(horizontal: 16, vertical: 8);
  }
}

class SampleMenuTwo extends StatelessWidget {
  const SampleMenuTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? context.width() / 3 : context.width() / 1,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: radius(defaultRadius),
          color: context.scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const VegComponent(size: 18),
                  10.width,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppPalette.primaryColor.withAlpha(30),
                        borderRadius: radius(defaultRadius)),
                    child: Text(context.localizations!.newKey,
                        style: boldTextStyle(
                            size: 12, color: AppPalette.primaryColor)),
                  ).cornerRadiusWithClipRRect(2),
                ],
              ),
              priceWidget(
                  currency: '\$',
                  price: '25.55',
                  style: boldTextStyle(color: AppPalette.primaryColor)),
            ],
          ),
          8.height,
          Text('Italian Pizza',
              style: boldTextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          8.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Divider(thickness: 1, color: context.dividerColor),
              8.height,
              const SampleAddButton(),
            ],
          ),
        ],
      ),
    );
  }
}

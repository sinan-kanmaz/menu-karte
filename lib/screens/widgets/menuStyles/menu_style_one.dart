import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/core/utils/constants.dart';
import 'package:qrmenu/screens/dashboard_screen/widgets/veg_widget.dart';

class MenuComponentStyleOne extends StatelessWidget {
  final Menu menu;
  final VoidCallback? callback;

  const MenuComponentStyleOne({super.key, required this.menu, this.callback});

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
                      if (menu.isVeg != null)
                        if (menu.isVeg!) const VegComponent(size: 18),
                      if (menu.isVeg != null)
                        if (!menu.isVeg!) const NonVegComponent(size: 18),
                      if (menu.isVeg == null) const NonVegComponent(size: 18),
                      10.width,
                      if (menu.isNew != null)
                        if (menu.isNew!)
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
                  Text(
                      menu.translated!.name!
                          .getStringName(context.localizations!.localeName),
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  4.height,
                  if (menu.translated!.description != null)
                    Text(
                        menu.translated!.description!
                            .getStringName(context.localizations!.localeName),
                        style: secondaryTextStyle(
                            size: 12, color: AppPalette.bodyColor)),
                  4.height,
                  if (menu.ingredient != null)
                    Text(
                      menu.ingredient
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", ""),
                      style: secondaryTextStyle(
                          size: 12, color: AppPalette.bodyColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ).expand(),
              if (menu.menuImage != null)
                if (menu.menuImage!.isNotEmpty)
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.dividerColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: cachedImage(menu.menuImage!.first.validate(),
                          fit: BoxFit.cover),
                    ),
                  ),
            ],
          ),
          8.height,
          Divider(thickness: 1, color: context.dividerColor),
          8.height,
          if (menu.amounts == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                priceWidget(
                    currency: '€',
                    price: '${menu.price.validate()}',
                    style: boldTextStyle(color: AppPalette.primaryColor)),
                // UserAddItemComponent(
                //   menuData: widget.menu,
                //   quantity: 0,
                //   callback: () {},
                // ),
              ],
            ),
          if (menu.amounts != null)
            if (menu.amounts!.isEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  priceWidget(
                    currency: '€',
                    price: '${menu.price.validate()}',
                    style: boldTextStyle(color: AppPalette.primaryColor),
                  ),
                ],
              ),
          if (menu.amounts != null)
            if (menu.amounts!.isNotEmpty)
              Wrap(
                children: List.generate(
                  menu.amounts!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      label: Text(
                        "${menu.amounts![index].amount} ${menu.amounts![index].unit} -- ${AppConstant.currencyFormat(context.localizations!.localeName, menu.amounts![index].unitPrice!)}",
                        style: boldTextStyle(color: AppPalette.primaryColor),
                      ),
                    ),
                  ),
                ),
              )
        ],
      ),
    ).onTap(() {
      if (callback != null) callback!.call();
    }, borderRadius: radius(6)).paddingSymmetric(horizontal: 16, vertical: 8);
  }
}

class SampleMenuOne extends StatelessWidget {
  const SampleMenuOne({Key? key}) : super(key: key);

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
                        child: Text('New',
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
                  4.height,
                  Text('a perfect crust, tangy tomato sauce, fresh mozzarella',
                      style: secondaryTextStyle(
                          size: 12, color: AppPalette.bodyColor)),
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
            ],
          ),
        ],
      ),
    );
  }
}

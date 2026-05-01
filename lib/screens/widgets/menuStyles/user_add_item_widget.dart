import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

// ignore: must_be_immutable
class UserAddItemComponent extends StatefulWidget {
  int? quantity;
  Menu? menuData;
  VoidCallback? callback;

  UserAddItemComponent({this.quantity, this.menuData, this.callback});

  @override
  _UserAddItemComponentState createState() => _UserAddItemComponentState();
}

class _UserAddItemComponentState extends State<UserAddItemComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.quantity == 0) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor, borderRadius: radius(8)),
        child: Text('language.lblAddToCart}', style: boldTextStyle(size: 14)),
      ).onTap(() {
        widget.quantity = 1;
        // addToCart(
        //     menuData: widget.menuData!, quantity: widget.quantity.validate());
        widget.callback?.call();
        setState(() {});
      });
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor, borderRadius: radius(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            4.width,
            const Icon(LineIcons.minus, size: 20, color: AppPalette.bodyColor)
                .onTap(() {
              widget.quantity = widget.quantity.validate() - 1;
              // reduceFromCart(
              //     quantity: widget.quantity.validate(),
              //     menuData: widget.menuData!);
              widget.callback?.call();
              setState(() {});
            }),
            12.width,
            Text('${widget.quantity.validate()}',
                style: boldTextStyle(size: 18)),
            12.width,
            const Icon(LineIcons.plus, size: 20, color: AppPalette.bodyColor)
                .onTap(() {
              widget.quantity = widget.quantity.validate() + 1;
              // addToCart(
              //     menuData: widget.menuData!,
              //     quantity: widget.quantity.validate());
              widget.callback?.call();
              setState(() {});
            }),
          ],
        ),
      );
    }
  }
}

class SampleAddButton extends StatefulWidget {
  const SampleAddButton({super.key});

  @override
  State<SampleAddButton> createState() => _SampleAddButtonState();
}

class _SampleAddButtonState extends State<SampleAddButton> {
  int quantity = 2;

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor, borderRadius: radius(8)),
        child: Text('language.lblAddToCart}', style: boldTextStyle(size: 14)),
      ).onTap(() {
        quantity = 1;
        setState(() {});
      });
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor, borderRadius: radius(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            4.width,
            const Icon(LineIcons.minus, size: 20, color: AppPalette.bodyColor)
                .onTap(() {
              quantity = quantity.validate() - 1;
              setState(() {});
            }),
            12.width,
            Text('$quantity', style: boldTextStyle(size: 18)),
            12.width,
            const Icon(LineIcons.plus, size: 20, color: AppPalette.bodyColor)
                .onTap(() {
              quantity = quantity.validate() + 1;
              setState(() {});
            }),
          ],
        ),
      );
    }
  }
}

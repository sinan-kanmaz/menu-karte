import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

InputDecoration inputDecoration(BuildContext context,
    {String? hint,
    String? label,
    TextStyle? textStyle,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon}) {
  return InputDecoration(
    contentPadding: contentPadding,
    labelText: label,
    hintText: hint,
    hintStyle: textStyle ?? secondaryTextStyle(),
    labelStyle: textStyle ?? secondaryTextStyle(),
    prefix: prefix,
    prefixIcon: prefixIcon,
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: const BorderSide(color: Colors.red, width: 1.0)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: const BorderSide(color: Colors.red, width: 1.0)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(width: 1.0, color: context.dividerColor)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(width: 1.0, color: context.dividerColor)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide:
            const BorderSide(color: AppPalette.primaryColor, width: 1.0)),
    alignLabelWithHint: true,
  );
}

Future<File> getImageSource({bool isCamera = true}) async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery);
  return File(pickedImage!.path);
}

String createPath(String input) {
  return input
      .replaceAll(" ", "-")
      .replaceAll("ç", "c")
      .replaceAll("ğ", "g")
      .replaceAll("ö", "o")
      .replaceAll("ş", "s")
      .replaceAll("ı", "i")
      .replaceAll("ü", "u")
      .toLowerCase();
}

// String parseHtmlString(String? htmlString) {
//   return parse(parse(htmlString).body!.text).documentElement!.text;
// }

// Future<List<File>> getMultipleFile() async {
//   FilePickerResult? filePickerResult;
//   List<File> imgList = [];
//   filePickerResult = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'jpeg']);

//   if (filePickerResult != null) {
//     imgList = filePickerResult.paths.map((path) => File(path!)).toList();
//   }
//   return imgList;
// }

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

// void reduceFromCart(
//     {required int quantity, required Menu menuData, Function? set}) {
//   menuStore.cartList.forEach((element) {
//     if (quantity > 0 && element.menu == menuData) {
//       element.quantity = quantity;
//     } else if (quantity == 0) {
//       QuantityMenuModel data =
//           menuStore.cartList.firstWhere((element) => element.menu == menuData);
//       menuStore.cartList.remove(data);
//     }
//   });
// }

// void launchUrlCustomTab(String? url) {
//   if (url.validate().isNotEmpty) {
//     try {
//       launch(
//         url!,
//         customTabsOption: CustomTabsOption(
//           enableDefaultShare: true,
//           enableInstantApps: true,
//           enableUrlBarHiding: true,
//           showPageTitle: true,
//           toolbarColor: primaryColor,
//         ),
//         safariVCOption: SafariViewControllerOption(
//           preferredBarTintColor: primaryColor,
//           preferredControlTintColor: Colors.white,
//           barCollapsingEnabled: true,
//           entersReaderIfAvailable: false,
//           dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//         ),
//       );
//     } on Exception catch (e) {
//       log('Error : $e');
//     }
//   }
// }

// void addToCart({required int quantity, required Menu menuData}) {
//   if (menuStore.cartList.isEmpty) {
//     menuStore.setCartList(menuData, quantity);
//   } else {
//     if (menuStore.cartList.any((element) => element.menu == menuData)) {
//       QuantityMenuModel data =
//           menuStore.cartList.firstWhere((element) => element.menu == menuData);
//       data.quantity = quantity;
//     } else {
//       menuStore.setCartList(menuData, quantity);
//     }
//   }
// }

// int totalItems() {
//   int itemCount = 0;
//   menuStore.cartList.forEach((element) {
//     itemCount = itemCount + element.quantity.validate();
//   });
//   return itemCount;
// }

// int totalCost() {
//   int totalCost = 0;
//   menuStore.cartList.forEach((element) {
//     totalCost = totalCost +
//         (element.quantity.validate() * element.menu!.price.validate());
//   });

//   return totalCost;
// }

Widget priceWidget({TextStyle? style, String? price, String? currency}) {
  return Text('$currency$price', style: style);
}

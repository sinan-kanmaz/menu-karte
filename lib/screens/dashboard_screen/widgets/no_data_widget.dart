import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/constants.dart';

class NoDataWidget extends StatelessWidget {
  final String categoryName;

  const NoDataWidget({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          cachedImage(AppImages.noDataImage, height: 250),
          16.height,
          Text('NoMenuFor ${categoryName.validate(value: "All")} ',
              style: boldTextStyle(size: 20)),
        ],
      ).paddingTop(80),
    ).center();
  }
}

class NoRestaurantWidget extends StatelessWidget {
  final String errorName;

  const NoRestaurantWidget({super.key, required this.errorName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cachedImage(AppImages.noDataImage, height: 200),
          16.height,
          Text(errorName, style: boldTextStyle(size: 20)),
        ],
      ).paddingTop(80),
    );
  }
}

class NoMenuComponent extends StatelessWidget {
  final String? categoryName;

  const NoMenuComponent({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          cachedImage("assets/images/no_data.png", height: 250),
          16.height,
          Text(
              categoryName == null
                  ? context.localizations!.noMenuFor("All")
                  : context.localizations!.noMenuFor(categoryName!),
              style: boldTextStyle(size: 20)),
        ],
      ).paddingTop(80),
    ).center();
  }
}

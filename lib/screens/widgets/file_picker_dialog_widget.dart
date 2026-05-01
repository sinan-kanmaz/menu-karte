import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';

import 'package:qrmenu/core/utils/constants.dart';

class FilePickerDialog extends StatelessWidget {
  final bool isSelected;

  const FilePickerDialog({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingItemWidget(
            title: context.localizations!.removeImage,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(Icons.close, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.CANCEL);
            },
          ).visible(isSelected),
          SettingItemWidget(
            title: context.localizations!.camera,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.camera, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.CAMERA);
            },
          ).visible(!isWeb),
          SettingItemWidget(
            title: context.localizations!.gallery,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.image_1, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.GALLERY);
            },
          ),
        ],
      ),
    );
  }
}

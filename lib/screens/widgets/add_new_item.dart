import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

class AddNewComponentItem extends StatelessWidget {
  final void Function()? onTap;

  const AddNewComponentItem({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(context.localizations!.addNew,
          style: boldTextStyle(color: AppPalette.primaryColor)),
    );
  }
}

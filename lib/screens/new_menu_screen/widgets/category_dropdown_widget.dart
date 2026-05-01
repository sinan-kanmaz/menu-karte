import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/screens/cotegories_screen/providers/categories_provider.dart';

class CategoryDropdownComponent extends StatefulWidget {
  final MenuCategory? defaultValue;
  final Function(MenuCategory value) onValueChanged;
  final bool isValidate;

  CategoryDropdownComponent({
    this.defaultValue,
    required this.onValueChanged,
    required this.isValidate,
  });

  @override
  _CategoryDropdownComponentState createState() =>
      _CategoryDropdownComponentState();
}

class _CategoryDropdownComponentState extends State<CategoryDropdownComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return DropdownButtonFormField<MenuCategory>(
        onChanged: (value) {
          widget.onValueChanged.call(value!);
        },
        value: widget.defaultValue,
        isExpanded: true,
        validator: widget.isValidate
            ? (c) {
                if (c == null) return errorThisFieldRequired;
                return null;
              }
            : null,
        decoration: inputDecoration(context,
                label: context.localizations!.chooseCategory)
            .copyWith(
          prefixIcon: Image.asset('assets/images/ic_Category.png',
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
            MenuCategory data = ref.read(categoriesProvider)[index];
            return DropdownMenuItem(
              value: data,
              child: Text(data.translateValues!.name.validate(),
                  style: primaryTextStyle()),
            );
          },
        ),
      );
    });
  }
}

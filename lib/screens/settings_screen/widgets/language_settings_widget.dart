import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/settings_box.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import '../../../../core/l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.localizations!.appLanguage,
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        showBack: Navigator.canPop(context) ? true : false,
        titleTextStyle: boldTextStyle(
            size: 18,
            color: context.theme.brightness == Brightness.dark
                ? Colors.white
                : AppPalette.headingColor),
      ),
      body: Consumer(builder: (context, ref, _) {
        return Column(
          children: [
            Divider(
                thickness: 1,
                color: context.dividerColor,
                endIndent: 16,
                indent: 16),
            ...List.generate(
              AppLocalizations.supportedLocales.length,
              (index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  color: context.localizations!.localeName ==
                          AppLocalizations.supportedLocales[index].languageCode
                      ? context.cardColor
                      : context.scaffoldBackgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Image.asset("data.flag.validate()", width: 34),
                          16.width,
                          Text(
                            AppLocalizations.supportedLocales[index]
                                .toLanguageTag()
                                .toUpperCase(),
                            style: boldTextStyle(
                                size: 18,
                                color: 1 == index
                                    ? context.iconColor
                                    : AppPalette.bodyColor),
                          ),
                        ],
                      ),
                      if (context.localizations!.localeName ==
                          AppLocalizations.supportedLocales[index].languageCode)
                        const Icon(Icons.check, color: AppPalette.primaryColor)
                    ],
                  ).onTap(
                    () async {
                      ref.read(settingsBoxProvider).put(
                          "language",
                          AppLocalizations
                              .supportedLocales[index].languageCode);

                      finish(context);
                    },
                    borderRadius: radius(defaultRadius),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

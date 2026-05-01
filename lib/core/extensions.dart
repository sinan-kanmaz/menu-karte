import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'theme/app_theme.dart';
import 'theme/text_theme_extensions.dart';

extension ThemeGetter on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  AppLocalizations? get localizations => AppLocalizations.of(this);
}

extension AppThemeExtension on ThemeData {
  // AppColorsExtension get appColors =>
  //     extension<AppColorsExtension>() ?? AppTheme.light.appColors;

  TextThemeExtension get appTextTheme =>
      extension<TextThemeExtension>() ?? AppTheme.light.appTextTheme;
}

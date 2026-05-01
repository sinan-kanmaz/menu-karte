import 'app_typography.dart';
import 'dark_theme.dart';
import 'light_theme.dart';
import 'text_theme_extensions.dart';

class AppTheme {
  static final light = lightTheme.copyWith(
    extensions: [_lightTextTheme],
  );

  static final dark = darkTheme.copyWith(
    extensions: [_darkTextTheme],
  );

  static final _lightTextTheme = TextThemeExtension(
    boldTextStyle: AppTypography.boldTextStyle,
  );

  static final _darkTextTheme = TextThemeExtension(
    boldTextStyle: AppTypography.boldTextStyleDark,
  );
}

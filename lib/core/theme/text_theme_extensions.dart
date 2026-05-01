import 'package:flutter/material.dart';

class TextThemeExtension extends ThemeExtension<TextThemeExtension> {
  TextThemeExtension({
    required this.boldTextStyle,
  });

  final TextStyle? boldTextStyle;

  @override
  ThemeExtension<TextThemeExtension> copyWith({
    TextStyle? boldTextStyle,
  }) {
    return TextThemeExtension(
      boldTextStyle: boldTextStyle ?? this.boldTextStyle,
    );
  }

  @override
  ThemeExtension<TextThemeExtension> lerp(
    covariant ThemeExtension<TextThemeExtension>? other,
    double t,
  ) {
    if (other is! TextThemeExtension) {
      return this;
    }

    return TextThemeExtension(
      boldTextStyle: TextStyle.lerp(boldTextStyle, other.boldTextStyle, t)!,
    );
  }
}

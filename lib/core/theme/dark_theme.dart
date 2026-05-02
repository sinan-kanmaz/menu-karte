import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_palette.dart';

ThemeData darkTheme = ThemeData(
  // brightness: Brightness.dark,
  colorScheme: ColorScheme(
    primary: Colors.white,
    primaryContainer: createMaterialColor(Colors.white),
    secondary: Colors.white,
    secondaryContainer: createMaterialColor(Colors.white),
    surface: AppPalette.scaffoldColorDark,
    background: AppPalette.scaffoldColorDark,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.black,
    onError: Colors.redAccent,
    brightness: Brightness.dark,
  ),
  primaryColor: AppPalette.primaryColor,
  scaffoldBackgroundColor: AppPalette.scaffoldColorDark,
  fontFamily: GoogleFonts.openSans().fontFamily,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppPalette.scaffoldSecondaryDark),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: GoogleFonts.openSansTextTheme(),
  dialogBackgroundColor: AppPalette.scaffoldSecondaryDark,
  unselectedWidgetColor: Colors.white60,
  dividerColor: Colors.white12,
  cardColor: AppPalette.scaffoldSecondaryDark,
  dialogTheme: DialogThemeData(shape: dialogShape()),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(Colors.white),
    checkColor: MaterialStateProperty.all(Colors.black),
    overlayColor: MaterialStateProperty.all(const Color(0xFF5D5F6E)),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(Colors.white),
    overlayColor: MaterialStateProperty.all(const Color(0xFF5D5F6E)),
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      statusBarColor: AppPalette.scaffoldColorDark,
    ),
  ),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

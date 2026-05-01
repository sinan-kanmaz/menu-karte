import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_palette.dart';

ThemeData lightTheme = ThemeData(
  // brightness: Brightness.light,

  colorScheme: ColorScheme(
    primary: AppPalette.primaryColor,
    primaryContainer: createMaterialColor(AppPalette.primaryColor),
    secondary: AppPalette.secondaryColor,
    secondaryContainer: createMaterialColor(AppPalette.secondaryColor),
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.black,
    onError: Colors.redAccent,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF0F6FB),
  //scaffoldBackgroundColor: Colors.white,
  fontFamily: GoogleFonts.openSans().fontFamily,
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: Colors.white),
  iconTheme: const IconThemeData(color: AppPalette.scaffoldSecondaryDark),
  textTheme: GoogleFonts.openSansTextTheme(),
  dialogBackgroundColor: Colors.white,
  unselectedWidgetColor: Colors.black,
  dividerColor: AppPalette.borderColor,
  cardColor: Colors.white,
  dialogTheme: DialogTheme(shape: dialogShape()),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0xFFF0F6FB)),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(AppPalette.primaryColor),
    overlayColor: MaterialStateProperty.all(const Color(0xFF5D5F6E)),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(AppPalette.primaryColor),
    overlayColor: MaterialStateProperty.all(const Color(0xFF5D5F6E)),
  ),
  tabBarTheme: const TabBarTheme(
      labelColor: Colors.black, unselectedLabelColor: Colors.grey),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const mBaseUrl = '';
const mFirebaseUrl = '';

class AppConstant {
  static FilteringTextInputFormatter doubleRegExp =
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));

  static currencyFormat(String locale, double amount) {
    return NumberFormat.simpleCurrency(locale: locale, name: "€")
        .format(amount);
  }

  static getLocaleName(String localeName) {
    String locale = "";
    switch (localeName) {
      case "en":
        locale = "English";
        break;
      case "de":
        locale = "Deutsch";
        break;
      case "nl":
        locale = "Nederlands";
        break;
      case "tr":
        locale = "Türkçe";
        break;
      case "fr":
        locale = "Français";
        break;
      default:
        locale = "Deutsch";
    }
    return locale;
  }

  static Map<String, String> additives = {
    "1": "MIT KONSERVIERUNGSSTOFF",
    "2": "MIT FARBSTOFF",
    "3": "MIT ANTIOXIDATIONSMITTEL",
    "4": "MIT SÜSSUNGSMITTEL",
    "8": "MIT PHOSPHOR",
    "9": "GESCHWEFELT",
    "10": "CHININHALTIG",
    "11": "KOFFEINHALTIG",
    "12": "MIT GESCHMACKSVERSTÄRKER 13 GESCHWÄRZT",
    "14": "GEWACHST",
    "15": "GENTECHNISCH VERÄNDERT"
  };

  static Map<String, String> allergens = {
    "A": "GLUTENHALTIGES GETREIDE",
    "B": "KREBSTIERE",
    "C": "EIER UND EIERERZEUGNISSE",
    "D": "FISCH UND FISCHERZEUGNISSE",
    "E": "ERDNÜSSE UND ERDNUSS-ERZEUGNISSE",
    "F": "SOJA UND SOJAERZEUGNISSE",
    "G": "MILCH UND MILCHER-ZEUGNISSE",
    "H": "SCHALENFRÜCHTE",
    "I": "SELLERIE UND SELLERIE-ERZEUGNISSE",
    "J": "SENF UND SENFERZEUGNISSE",
    "K": "SESAMSAMEN",
    "L": "LUPINEN",
    "M": "WEICHTIERE (SCHNECKEN, MUSCHELN, KALAMARE, AUSTERN)",
    "N": "SCHWEFELDIOXID | SULPHIDE"
  };
}

class AppImages {
  static const appLogo = "images/qr-menu.png";
  static const noDataImage = "images/no_data.png";
  static const paperLess = "images/paper.png";
  static const language = "images/language.png";
  static const theme = "images/theme.png";
}

enum FileTypes { CANCEL, CAMERA, GALLERY }

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
    Locale('tr')
  ];

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addAllergen.
  ///
  /// In en, this message translates to:
  /// **'Add Allergen'**
  String get addAllergen;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get addImage;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addIngredient;

  /// No description provided for @addMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Add Menu Item'**
  String get addMenuItem;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @addRestaurantManager.
  ///
  /// In en, this message translates to:
  /// **'Add Restaurant Manager'**
  String get addRestaurantManager;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @aResetPasswordLinkWillBeSentToTheaboveEnteredEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'A reset password link will be sent to the above entered email address'**
  String get aResetPasswordLinkWillBeSentToTheaboveEnteredEmailAddress;

  /// No description provided for @bothPasswordShouldBeMatched.
  ///
  /// In en, this message translates to:
  /// **'Both password should be matched'**
  String get bothPasswordShouldBeMatched;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @categoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Category Description'**
  String get categoryDescription;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **' Change Password'**
  String get changePassword;

  /// No description provided for @chooseAnAction.
  ///
  /// In en, this message translates to:
  /// **'Choose An Action'**
  String get chooseAnAction;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get chooseCategory;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get chooseImage;

  /// No description provided for @chooseMenuItemImages.
  ///
  /// In en, this message translates to:
  /// **'Choose Menu Item Images'**
  String get chooseMenuItemImages;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @doYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete {menu}?'**
  String doYouWantToDelete(Object menu);

  /// No description provided for @doYouWantToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Do You Want To Update Profile?'**
  String get doYouWantToUpdateProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterCategoryDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Category Details'**
  String get enterCategoryDetails;

  /// No description provided for @enterFoodItemDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Food Item Details'**
  String get enterFoodItemDetails;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email'**
  String get enterValidEmail;

  /// No description provided for @enterYourProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Profile Details'**
  String get enterYourProfileDetails;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @imageSupport.
  ///
  /// In en, this message translates to:
  /// **'Support : JPG, PNG, JPEG'**
  String get imageSupport;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @jain.
  ///
  /// In en, this message translates to:
  /// **'Jain'**
  String get jain;

  /// No description provided for @jainDescription.
  ///
  /// In en, this message translates to:
  /// **'Catering to your food preferences is our goal, explore a dedicated Jain food menu to find your perfect one'**
  String get jainDescription;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @login_successFully.
  ///
  /// In en, this message translates to:
  /// **'Login SuccessFully'**
  String get login_successFully;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @menu_items.
  ///
  /// In en, this message translates to:
  /// **'Menu Items'**
  String get menu_items;

  /// No description provided for @menuStyle.
  ///
  /// In en, this message translates to:
  /// **'Menu Style'**
  String get menuStyle;

  /// No description provided for @menuTabs.
  ///
  /// In en, this message translates to:
  /// **'Menu Tabs'**
  String get menuTabs;

  /// No description provided for @missingInformation.
  ///
  /// In en, this message translates to:
  /// **'Missing Information'**
  String get missingInformation;

  /// No description provided for @myRestaurants.
  ///
  /// In en, this message translates to:
  /// **'My Restaurants'**
  String get myRestaurants;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @newDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore the exclusive selection of new dishes and delicacies cooked to tingle your taste buds'**
  String get newDescription;

  /// No description provided for @newKey.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newKey;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @noMenuFor.
  ///
  /// In en, this message translates to:
  /// **'No Menu For  {menu}'**
  String noMenuFor(Object menu);

  /// No description provided for @noRestaurant.
  ///
  /// In en, this message translates to:
  /// **'No Restaurant'**
  String get noRestaurant;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @ohSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oh Something Went Wrong'**
  String get ohSomethingWentWrong;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @orderIsReqiered.
  ///
  /// In en, this message translates to:
  /// **'Order is reqiered'**
  String get orderIsReqiered;

  /// No description provided for @otherDetailsToAdd.
  ///
  /// In en, this message translates to:
  /// **'Other Details To Add'**
  String get otherDetailsToAdd;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @passwordLengthShouldBeMoreThanSix.
  ///
  /// In en, this message translates to:
  /// **'Password length should be more than six'**
  String get passwordLengthShouldBeMoreThanSix;

  /// No description provided for @pleaseSelectACategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectACategory;

  /// No description provided for @pleaseSelectAMenuStyle.
  ///
  /// In en, this message translates to:
  /// **'Please select a menu style'**
  String get pleaseSelectAMenuStyle;

  /// No description provided for @pleaseSelectaTab.
  ///
  /// In en, this message translates to:
  /// **'Please select a tab'**
  String get pleaseSelectaTab;

  /// No description provided for @pleaseSpecifyAValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please specify a valid price'**
  String get pleaseSpecifyAValidPrice;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @popularDescription.
  ///
  /// In en, this message translates to:
  /// **'Not sure what to order? Check out the highly recommended or Bestsellers and most popular cuisines and delicacies'**
  String get popularDescription;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @printMenu.
  ///
  /// In en, this message translates to:
  /// **'Print Menu'**
  String get printMenu;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordLinkHasSentYourMail.
  ///
  /// In en, this message translates to:
  /// **'Reset password link has sent your mail'**
  String get resetPasswordLinkHasSentYourMail;

  /// No description provided for @restaurantStyle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Style'**
  String get restaurantStyle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @scanForOurOnlineMenu.
  ///
  /// In en, this message translates to:
  /// **'Scan For Our Online Menu'**
  String get scanForOurOnlineMenu;

  /// No description provided for @searchYourRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Search Your Restaurant...'**
  String get searchYourRestaurant;

  /// No description provided for @selectAMenu.
  ///
  /// In en, this message translates to:
  /// **'Select a menu'**
  String get selectAMenu;

  /// No description provided for @selectedMenuStyle.
  ///
  /// In en, this message translates to:
  /// **'Selected Menu Style'**
  String get selectedMenuStyle;

  /// No description provided for @selectImgNote.
  ///
  /// In en, this message translates to:
  /// **'Note: You can upload images with \\\'jpg\\\',\\\'png\\\',\\\'jpeg\\\' extensions & you can select multiple images'**
  String get selectImgNote;

  /// No description provided for @selectMenuStyles.
  ///
  /// In en, this message translates to:
  /// **'Select Menu Styles'**
  String get selectMenuStyles;

  /// No description provided for @setMenuStyle.
  ///
  /// In en, this message translates to:
  /// **'Set Menu Style'**
  String get setMenuStyle;

  /// No description provided for @setQrStyle.
  ///
  /// In en, this message translates to:
  /// **'Set Qr Style'**
  String get setQrStyle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @special.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get special;

  /// No description provided for @specialDescription.
  ///
  /// In en, this message translates to:
  /// **'If you haven’t tried our exquisite collection of cuisines, don’t miss out on our Special menu served all for you.'**
  String get specialDescription;

  /// No description provided for @spicy.
  ///
  /// In en, this message translates to:
  /// **'Spicy'**
  String get spicy;

  /// No description provided for @spicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Hot and sizzling, if you are a fan of spicy cuisine, check out the special Spicy range of delicacies.'**
  String get spicyDescription;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @sweet.
  ///
  /// In en, this message translates to:
  /// **'Sweet'**
  String get sweet;

  /// No description provided for @sweetDescription.
  ///
  /// In en, this message translates to:
  /// **'A meal without Dessert is incomplete, tantalize your senses with our sweetest Dessert collection'**
  String get sweetDescription;

  /// No description provided for @theMenuHasBeenSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'The menu has been saved successfully'**
  String get theMenuHasBeenSavedSuccessfully;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @veg.
  ///
  /// In en, this message translates to:
  /// **'Veg'**
  String get veg;

  /// No description provided for @vegDescription.
  ///
  /// In en, this message translates to:
  /// **'Select from the exotic collection of vegetables, stirred and sautéed tossed and cooked with perfection'**
  String get vegDescription;

  /// No description provided for @welcomeBackHaveANiceDay.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back Have A Nice Day'**
  String get welcomeBackHaveANiceDay;

  /// No description provided for @welcomeBackYouHaveBeenMissedForLongTime.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back, You Have Been \n Missed For Long Time'**
  String get welcomeBackYouHaveBeenMissedForLongTime;

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {name}'**
  String welcomeToApp(Object name);

  /// No description provided for @your_password_has_been_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get your_password_has_been_changed_successfully;

  /// No description provided for @yourNewPasswordMustBeDifferentFromPrevioususedPassword.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previous used password'**
  String get yourNewPasswordMustBeDifferentFromPrevioususedPassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'nl', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/global_providers/settings_box.dart';
import 'package:qrmenu/core/global_providers/user_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/screens/print_menu_screen/print_menu_screen.dart';
import 'package:qrmenu/screens/qr_generate_screen/qr_generate_screen.dart';
import 'package:qrmenu/screens/settings_screen/menu_style_screen.dart';
import 'package:qrmenu/screens/settings_screen/widgets/menu_tabs.dart';
import 'change_password_screen.dart';
import 'widgets/edit_profile_card.dart';
import 'widgets/language_settings_widget.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static String routeName = "/settings";

  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);
    return Scaffold(
      appBar: appBarWidget(
        context.localizations!.settings,
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        showBack: Navigator.canPop(context) ? true : false,
        titleTextStyle: boldTextStyle(
            size: 18,
            color: context.theme.brightness == Brightness.dark
                ? Colors.white
                : AppPalette.headingColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
                color: context.dividerColor,
                thickness: 1,
                indent: 16,
                endIndent: 16),
            if (user != null) const EditProfileCard(),
            SettingItemWidget(
              title: context.localizations!.darkMode,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              leading: Image.asset('assets/images/ic_Theme.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color: context.theme.brightness == Brightness.dark
                      ? context.iconColor
                      : AppPalette.bodyColor),
              titleTextStyle: getLitItemTitleStyle(),
              trailing: Transform.scale(
                scale: 0.7,
                alignment: Alignment.centerRight,
                child: CupertinoSwitch(
                  value: context.theme.brightness == Brightness.dark,
                  onChanged: (value) {
                    if (value) {
                      ref.read(settingsBoxProvider).put('theme', 'dark');
                    } else {
                      ref.read(settingsBoxProvider).put('theme', 'light');
                    }
                  },
                  activeColor: AppPalette.primaryColor,
                  trackColor: context.dividerColor,
                ),
              ),
            ),
            if (user != null)
              SettingItemWidget(
                leading: Image.asset('assets/images/ic_Lock.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.theme.brightness == Brightness.dark
                        ? context.iconColor
                        : AppPalette.bodyColor),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                title: context.localizations!.changePassword,
                titleTextStyle: getLitItemTitleStyle(),
                onTap: () {
                  const ChangePasswordScreen().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Slide);
                },
                trailing: trailingIcon(),
              ),
            // SettingItemWidget(
            //   leading: Image.asset('assets/images/ic_Users.png',
            //       height: 24,
            //       width: 24,
            //       fit: BoxFit.cover,
            //       color: context.theme.brightness == Brightness.dark
            //           ? context.iconColor
            //           : AppPalette.bodyColor),
            //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            //   title: context.localizations!.addRestaurantManager,
            //   titleTextStyle: boldTextStyle(size: 16),
            //   onTap: () {
            //     // push(AddRestaurantMangerScreen(),
            //     //     pageRouteAnimation: PageRouteAnimation.Slide);
            //   },
            //   trailing: trailingIcon(),
            // ).visible(true),
            SettingItemWidget(
              leading: Image.asset('assets/images/ic_Language.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color: context.theme.brightness == Brightness.dark
                      ? context.iconColor
                      : AppPalette.bodyColor),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              title: context.localizations!.appLanguage,
              titleTextStyle: getLitItemTitleStyle(),
              trailing: trailingIcon(),
              onTap: () {
                const LanguageScreen().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Slide);
              },
            ),

            if (user != null)
              SettingItemWidget(
                title: context.localizations!.printMenu,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Icon(Icons.print,
                    color: context.theme.brightness == Brightness.dark
                        ? context.iconColor
                        : AppPalette.bodyColor),
                titleTextStyle: getLitItemTitleStyle(),
                onTap: () {
                  PrintMenuScreen(
                    restaurant: ref.read(userStateProvider)!,
                  ).launch(context);
                },
                trailing: trailingIcon(),
              ),
            if (user != null)
              SettingItemWidget(
                title: context.localizations!.restaurantStyle,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('assets/images/ic_Menu_Style.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.theme.brightness == Brightness.dark
                        ? context.iconColor
                        : AppPalette.bodyColor),
                titleTextStyle: getLitItemTitleStyle(),
                onTap: () {
                  MenuStyleScreen(
                    restaurant: ref.read(userStateProvider)!,
                  ).launch(context);
                },
                trailing: trailingIcon(),
              ),

            if (user != null)
              SettingItemWidget(
                title: context.localizations!.menuTabs,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('assets/images/ic_Menu_Style.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.theme.brightness == Brightness.dark
                        ? context.iconColor
                        : AppPalette.bodyColor),
                titleTextStyle: getLitItemTitleStyle(),
                onTap: () {
                  // push(MenuStyleScreen(),
                  //     pageRouteAnimation: PageRouteAnimation.Slide);
                  const MenuTabs().launch(context);
                },
                trailing: trailingIcon(),
              ),
            if (user != null)
              SettingItemWidget(
                title: context.localizations!.setQrStyle,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('assets/images/ic_Qr_Style.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.theme.brightness == Brightness.dark
                        ? context.iconColor
                        : AppPalette.bodyColor),
                titleTextStyle: getLitItemTitleStyle(),
                onTap: () {
                  context.push(QrGenerateScreen.routeName);
                  // push(QrStyleScreen(),
                  //     pageRouteAnimation: PageRouteAnimation.Slide);
                },
                trailing: trailingIcon(),
              ),
            SettingItemWidget(
              title: context.localizations!.privacyPolicy,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              leading: Image.asset('assets/images/ic_Privacy.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color: context.theme.brightness == Brightness.dark
                      ? context.iconColor
                      : AppPalette.bodyColor),
              titleTextStyle: getLitItemTitleStyle(),
              onTap: () {
                // launchUrlCustomTab(Urls.privacyPolicyURL);
              },
            ),
            isWeb
                ? const Offstage()
                : SnapHelperWidget<PackageInfoData>(
                    onSuccess: (d) => SettingItemWidget(
                      leading: Image.asset('assets/images/ic_Rate.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.cover,
                          color: context.theme.brightness == Brightness.dark
                              ? context.iconColor
                              : AppPalette.bodyColor),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      titleTextStyle: boldTextStyle(size: 16),
                      title: "Rate Us",
                      onTap: () {
                        // launchUrlCustomTab('$playStoreBaseURL${d.packageName}');
                      },
                    ),
                    future: getPackageInfo(),
                  ),
            SettingItemWidget(
              leading: Image.asset('assets/images/ic_Help.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color: context.theme.brightness == Brightness.dark
                      ? context.iconColor
                      : AppPalette.bodyColor),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              titleTextStyle: getLitItemTitleStyle(),
              title: "Help Support",
              onTap: () {
                // launchUrlCustomTab(Urls.termsAndConditionURL);
              },
            ),
            isWeb
                ? const Offstage()
                : SettingItemWidget(
                    leading: Image.asset('assets/images/ic_share.png',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        color: context.theme.brightness == Brightness.dark
                            ? context.iconColor
                            : AppPalette.bodyColor),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    titleTextStyle: getLitItemTitleStyle(),
                    title: "Share",
                    onTap: () {
                      // Share.share(
                      //   'Share ${AppConstant.appName} app\n\n${AppConstant.appDescription}',
                      // );
                    },
                  ),
            SettingItemWidget(
              title: "About",
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              leading: Image.asset('assets/images/ic_About.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color: context.theme.brightness == Brightness.dark
                      ? context.iconColor
                      : AppPalette.bodyColor),
              titleTextStyle: getLitItemTitleStyle(),
              onTap: () {
                // push(AboutScreen(),
                //     pageRouteAnimation: PageRouteAnimation.Slide);
              },
              trailing: trailingIcon(isVersion: true),
            ),
          ],
        ),
      ),
      bottomNavigationBar: user == null
          ? null
          : AppButton(
              text: context.localizations!.logout.toUpperCase(),
              textStyle: boldTextStyle(color: Colors.white, size: 18),
              margin: const EdgeInsets.all(16),
              elevation: 0,
              color: AppPalette.primaryColor,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
              onTap: () {
                ref.read(authStateProvider.notifier).signOut();
              },
            ),
    );
  }

  Widget trailingIcon({bool? isVersion}) {
    if (isVersion.validate()) {
      return Row(
        children: [
          SnapHelperWidget(
            future: getPackageInfo(),
            onSuccess: (PackageInfoData snap) {
              return Text(snap.versionName.validate(),
                  style: secondaryTextStyle(color: AppPalette.bodyColor));
            },
          ),
          8.width,
          const Icon(Icons.arrow_forward_ios,
              color: AppPalette.bodyColor, size: 14),
        ],
      );
    } else {
      return const Icon(Icons.arrow_forward_ios,
          color: AppPalette.bodyColor, size: 14);
    }
  }

  TextStyle getLitItemTitleStyle() {
    return boldTextStyle(
        size: 16,
        color: context.theme.brightness == Brightness.dark
            ? context.iconColor
            : null);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController newPassCont = TextEditingController();
  TextEditingController confNewPassCont = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();
  bool isBussy = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
    });
  }

  Future<void> submit() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      setState(() {
        isBussy = true;
      });

      await ref
          .read(authStateProvider.notifier)
          .updatePassword(newPassCont.text.trim(), context)
          .then((value) {
        setState(() {
          isBussy = false;
        });

        if (value) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              content: Text(context
                  .localizations!.your_password_has_been_changed_successfully),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(context.localizations!.ok),
                )
              ],
            ),
          );
        }
      });

      // if (!result && mounted) {
      //   context.pop();
      // }

      // await changePassword(request).then((value) {
      //   toast(value.message.validate());
      //   appStore.setPassword(newPassCont.text.validate());

      //   finish(context);
      // });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.localizations!.changePassword,
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
          children: [
            Divider(
                thickness: 1,
                color: context.dividerColor,
                indent: 16,
                endIndent: 16),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: radius(defaultRadius)),
              child: Stack(
                children: [
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localizations!.resetPassword,
                          style: context.appTheme.appTextTheme.boldTextStyle,
                        ),
                        8.height,
                        Text(
                          context.localizations!
                              .yourNewPasswordMustBeDifferentFromPrevioususedPassword,
                          style:
                              secondaryTextStyle(color: AppPalette.bodyColor),
                        ),
                        16.height,
                        AppTextField(
                          controller: newPassCont,
                          textFieldType: TextFieldType.PASSWORD,
                          focus: newPassFocus,
                          nextFocus: confPassFocus,
                          textStyle: secondaryTextStyle(),
                          autoFillHints: const [AutofillHints.newPassword],
                          suffixIconColor: AppPalette.bodyColor,
                          suffixPasswordInvisibleWidget: Image.asset(
                            'assets/images/ic_Hide.png',
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                            color: AppPalette.bodyColor,
                          ).paddingAll(12),
                          suffixPasswordVisibleWidget: Image.asset(
                            'assets/images/ic_Show.png',
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                            color: AppPalette.bodyColor,
                          ).paddingAll(12),
                          decoration: inputDecoration(
                            context,
                            label: context.localizations!.newPassword,
                            textStyle: secondaryTextStyle(),
                          ).copyWith(
                            prefixIcon: Image.asset('assets/images/ic_Lock.png',
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.cover,
                                    color: AppPalette.bodyColor)
                                .paddingAll(12),
                          ),
                        ),
                        16.height,
                        AppTextField(
                          controller: confNewPassCont,
                          textFieldType: TextFieldType.PASSWORD,
                          suffixIconColor: AppPalette.bodyColor,
                          textInputAction: TextInputAction.done,
                          focus: confPassFocus,
                          textStyle: primaryTextStyle(),
                          autoFillHints: const [AutofillHints.newPassword],
                          suffixPasswordInvisibleWidget: Image.asset(
                            'assets/images/ic_Hide.png',
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                            color: AppPalette.bodyColor,
                          ).paddingAll(12),
                          suffixPasswordVisibleWidget: Image.asset(
                            'assets/images/ic_Show.png',
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                            color: AppPalette.bodyColor,
                          ).paddingAll(12),
                          decoration: inputDecoration(
                            context,
                            label: context.localizations!.confirmPassword,
                            textStyle:
                                secondaryTextStyle(color: AppPalette.bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('assets/images/ic_Lock.png',
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.cover,
                                    color: AppPalette.bodyColor)
                                .paddingAll(12),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) return errorThisFieldRequired;
                            if (value.length < passwordLengthGlobal) {
                              return context.localizations!
                                  .passwordLengthShouldBeMoreThanSix;
                            }
                            if (value.trim() != newPassCont.text.trim()) {
                              return context
                                  .localizations!.bothPasswordShouldBeMatched;
                            }

                            return null;
                          },
                          onFieldSubmitted: (s) {
                            submit();
                          },
                        ),
                        30.height,
                        AppButton(
                          text: context.localizations!.save.toUpperCase(),
                          width: context.width(),
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  defaultAppButtonRadius)),
                          enabled: isBussy ? false : true,
                          color: AppPalette.primaryColor,
                          elevation: 0,
                          textStyle:
                              boldTextStyle(color: Colors.white, size: 18),
                          onTap: () {
                            submit();
                          },
                        ),
                      ],
                    ),
                  ).visible(!isBussy),
                  Loader().visible(isBussy)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

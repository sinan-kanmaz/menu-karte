import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';

import 'forgot_password_widget.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  bool bussy = false;
  @override
  void initState() {
    super.initState();
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        bussy = true;
      });
      _formKey.currentState!.save();
      hideKeyboard(context);
      await ref
          .read(authStateProvider.notifier)
          .signIn(emailCont.text, passCont.text, context);
      setState(() {
        bussy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bussy) return Loader().visible(true);

    return Column(
      children: [
        16.height,
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.height,
              TextFormField(
                controller: emailCont,
                decoration: inputDecoration(
                  context,
                  label: context.localizations!.emailAddress,
                  textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
                  prefixIcon: Image.asset(
                    'assets/images/ic_Message.png',
                    height: 16,
                    width: 16,
                    fit: BoxFit.cover,
                    color: AppPalette.bodyColor,
                  ).paddingAll(12),
                ),
              ),
              // AppTextField(
              //   textInputAction: TextInputAction.next,
              //   textStyle: primaryTextStyle(),
              //   controller: emailCont,
              //   textFieldType: TextFieldType.EMAIL,
              //   decoration: inputDecoration(
              //     context,
              //     label: context.localizations!.emailAddress,
              //     textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
              //   ).copyWith(
              //     prefixIcon: Image.asset(
              //       'assets/images/ic_Message.png',
              //       height: 16,
              //       width: 16,
              //       fit: BoxFit.cover,
              //       color: AppPalette.bodyColor,
              //     ).paddingAll(12),
              //   ),
              // ),
              16.height,
              AppTextField(
                textStyle: primaryTextStyle(),
                controller: passCont,
                textFieldType: TextFieldType.PASSWORD,
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
                  label: context.localizations!.password,
                  textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
                ).copyWith(
                  prefixIcon: Image.asset('assets/images/ic_Lock.png',
                          height: 16,
                          width: 16,
                          fit: BoxFit.cover,
                          color: AppPalette.bodyColor)
                      .paddingAll(12),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (s) {
                  login();
                },
              ),
              8.height,
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              showInDialog(
                context,
                dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                builder: (_) => const ForgotPasswordDialog(),
              );
            },
            child: Text(
              context.localizations!.forgotPassword,
              style: primaryTextStyle(
                  size: 12,
                  color: AppPalette.primaryColor,
                  fontStyle: FontStyle.italic,
                  weight: FontWeight.w600),
            ),
          ),
        ),
        24.height,
        AppButton(
          text: context.localizations!.login.toUpperCase(),
          elevation: 0,
          width: context.width(),
          color: AppPalette.primaryColor,
          shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
          textStyle: boldTextStyle(color: Colors.white, size: 18),
          onTap: () {
            login();
          },
        ),
        100.height,
      ],
    );
  }
}

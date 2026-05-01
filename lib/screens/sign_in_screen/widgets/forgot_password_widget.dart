import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController forgotEmailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    forgotEmailController.dispose();
    _formKey.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.localizations!.forgotPassword,
              style: boldTextStyle(size: 20)),
          Text(
              context.localizations!
                  .aResetPasswordLinkWillBeSentToTheaboveEnteredEmailAddress,
              style: secondaryTextStyle()),
          16.height,
          AppTextField(
            controller: forgotEmailController,
            textFieldType: TextFieldType.EMAIL,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration(
              context,
              label: context.localizations!.emailAddress,
              textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
            ).copyWith(
                prefixIcon: Image.asset(
              'assets/images/ic_Message.png',
              height: 16,
              width: 16,
              fit: BoxFit.cover,
              color: AppPalette.bodyColor,
            ).paddingAll(12)),
            errorInvalidEmail: context.localizations!.enterValidEmail,
            errorThisFieldRequired: errorThisFieldRequired,
          ).visible(true, defaultWidget: Loader()),
          16.height,
          Consumer(builder: (context, ref, _) {
            return AppButton(
              width: context.width(),
              color: AppPalette.primaryColor,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  hideKeyboard(context);
                  ref
                      .read(authStateProvider.notifier)
                      .resetPassword(forgotEmailController.text, context);
                }
              },
              child: Text(context.localizations!.resetPassword,
                  style: boldTextStyle(color: Colors.white)),
            );
          }),
        ],
      ),
    );
  }
}

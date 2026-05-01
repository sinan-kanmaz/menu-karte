import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/flavors.dart';

import 'widgets/login_widget.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static String routeName = "/sign-in";

  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          !isWeb
              ? Tooltip(
                  message: "language.lblScanQRCode",
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: context.iconColor),
                    onPressed: () {
                      // QRScanner().launch(context,
                      //     pageRouteAnimation: PageRouteAnimation.Scale,
                      //     duration: 450.milliseconds);
                    },
                  ).paddingRight(16),
                )
              : const Offstage()
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(context.localizations!.welcomeToApp(F.title),
                style: primaryTextStyle(size: 22)),
            16.height,
            Text(context.localizations!.welcomeBackYouHaveBeenMissedForLongTime,
                style: secondaryTextStyle(color: AppPalette.bodyColor),
                textAlign: TextAlign.center),
            16.height,
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                borderRadius: radius(),
                color: context.cardColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  const LoginWidget(),
                ],
              ),
            ).paddingSymmetric(horizontal: 16, vertical: 8),
            30.height,
          ],
        ).paddingTop(20),
      ).center(),
    );
  }
}

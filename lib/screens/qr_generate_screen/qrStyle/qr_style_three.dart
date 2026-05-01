import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';

class QrComponentStyleThree extends ConsumerWidget {
  final GlobalKey qrKey;
  final String saveUrl;

  const QrComponentStyleThree({
    super.key,
    required this.qrKey,
    required this.saveUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authStateProvider)!;
    return Container(
      padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 32),
      width: context.width(),
      decoration: boxDecorationDefault(
          borderRadius: radiusOnly(bottomRight: 200, bottomLeft: 200),
          color: context.scaffoldBackgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          30.height,
          Text(
            context.localizations!.scanForOurOnlineMenu,
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 16),
          ),
          16.height,
          RepaintBoundary(
              key: qrKey,
              child: QrImageView(
                padding: const EdgeInsets.all(16),
                dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle),
                backgroundColor: context.theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppPalette.primaryColor.withAlpha(20),
                version: 4,
                data: saveUrl,
                size: 220,
                foregroundColor: Colors.black,
                errorStateBuilder: (cxt, err) {
                  return Text(context.localizations!.ohSomethingWentWrong,
                          textAlign: TextAlign.center)
                      .center();
                },
              ).cornerRadiusWithClipRRect(defaultRadius)),
          16.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              user.photoURL == null
                  ? const Offstage()
                  : cachedImage(
                      user.photoURL,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ).cornerRadiusWithClipRRect(80),
              8.width,
              Text(
                user.displayName.toString(),
                textAlign: TextAlign.center,
                style: boldTextStyle(
                    size: 30,
                    fontFamily: GoogleFonts.gloriaHallelujah().fontFamily),
              ),
            ],
          ),
          60.height,
        ],
      ),
    );
  }
}

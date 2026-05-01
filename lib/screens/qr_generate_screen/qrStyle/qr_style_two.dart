import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';

class QrComponentStyleTwo extends ConsumerWidget {
  final GlobalKey qrKey;
  final String saveUrl;

  const QrComponentStyleTwo({
    super.key,
    required this.qrKey,
    required this.saveUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authStateProvider)!;

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 32),
      width: context.width() - 32,
      decoration: boxDecorationDefault(
          borderRadius: radius(16),
          color: context.cardColor,
          border: Border.all(color: context.dividerColor, width: 3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: qrKey,
            child: QrImageView(
              version: 4,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle),
              dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle),
              data: saveUrl,
              size: 250,
              backgroundColor: context.theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.transparent,
              foregroundColor: Colors.black,
              errorStateBuilder: (cxt, err) {
                return Text(context.localizations!.ohSomethingWentWrong,
                        textAlign: TextAlign.center)
                    .center();
              },
            ),
          ),
          16.height,
          Text(
            context.localizations!.scanForOurOnlineMenu,
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 20),
          ),
          16.height,
          Text(
            user.displayName.toString(),
            textAlign: TextAlign.center,
            style: boldTextStyle(size: 36),
          ),
        ],
      ),
    ).center();
  }
}

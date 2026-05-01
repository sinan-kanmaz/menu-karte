// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/core/utils/get_style_widget.dart';
import 'package:qrmenu/flavors.dart';
import 'package:screenshot/screenshot.dart';

class QrGenerateScreen extends StatefulWidget {
  static String routeName = "/generate-qr";

  const QrGenerateScreen({super.key});

  @override
  State<QrGenerateScreen> createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int qrStyle = 1;

  String saveUrl = "";
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
  }

  void getScreenShot() async {
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? image) async {
      if (image != null) {
        final html.Blob blob = html.Blob([image], 'image/png');

        final String url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute('download', "menu")
          ..click();

        html.Url.revokeObjectUrl(url);
      }
    }).catchError((onError) {
      toast("$onError Please try again");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final user = ref.read(authStateProvider);
        saveUrl = "${F.baseUrl}/${createPath(user!.displayName.toString())}";
        return Scaffold(
          appBar: AppBar(
              title: Text(
                '${user.displayName} QR',
              ),
              // color: context.scaffoldBackgroundColor,
              actions: [
                DropdownButton(
                  value: qrStyle,
                  items: [1, 2, 3]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(findStyleValue(e)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      qrStyle = v!;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: context.iconColor),
                  onPressed: () {
                    getScreenShot();
                  },
                ),
                16.width,
              ],
              elevation: 0.5),
          backgroundColor:
              //  appStore.selectedQrStyle == language.lblQrStyle3?

              qrStyle == 3
                  ? context.scaffoldBackgroundColor
                  : Colors.white70.withOpacity(0.92)
          // : context.scaffoldBackgroundColor,
          ,
          body: Screenshot(
            controller: screenshotController,
            child: getQrStyleWidget(qrKey, saveUrl, qrStyle),
          ),
        );
      },
    );
  }

  String findStyleValue(int e) {
    switch (e) {
      case 1:
        return "Style 1";

      case 2:
        return "Style 2";
      case 3:
        return "Style 3";
      default:
        return "Style 1";
    }
  }
}

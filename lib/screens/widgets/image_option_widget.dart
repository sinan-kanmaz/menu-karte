import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/core/utils/constants.dart';

import 'file_picker_dialog_widget.dart';

// ignore: must_be_immutable
class ImageOptionComponent extends StatefulWidget {
  bool isRes;
  String? defaultImage;
  final String? name;
  final Function(File? image) onImageSelected;
  double? width;
  int? id;

  ImageOptionComponent(
      {super.key,
      this.defaultImage,
      required this.onImageSelected,
      this.name,
      this.width,
      this.id,
      required this.isRes});

  @override
  _ImageOptionComponentState createState() => _ImageOptionComponentState();
}

class _ImageOptionComponentState extends State<ImageOptionComponent> {
  File? image;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = !widget.defaultImage.isEmptyOrNull;
  }

  Widget getImagePlatform({double? height, double? width}) {
    if (!isUpdate) {
      if (image != null) {
        if (isWeb) {
          return Image.network(
            image!.path.validate(),
            alignment: Alignment.center,
            fit: BoxFit.cover,
            height: height,
            width: width,
          ).cornerRadiusWithClipRRect(defaultRadius);
        } else {
          return Image.file(
            File(image!.path.validate()),
            alignment: Alignment.center,
            fit: BoxFit.cover,
            height: height,
            width: width,
          ).cornerRadiusWithClipRRect(defaultRadius);
        }
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/image.png',
                height: 30, width: 30, fit: BoxFit.cover),
            8.height,
            Text(context.localizations!.chooseImage, style: boldTextStyle()),
          ],
        );
      }
    } else {
      if (image != null) {
        return Image.network(
          image!.path.validate(),
          alignment: Alignment.center,
          fit: BoxFit.cover,
          height: height,
          width: width,
        ).cornerRadiusWithClipRRect(defaultRadius);
        // return Image.file(
        //   File(image!.path.validate()),
        //   alignment: Alignment.center,
        //   fit: BoxFit.cover,
        //   height: height,
        //   width: width,
        // ).cornerRadiusWithClipRRect(defaultRadius);
      } else {
        return cachedImage(widget.defaultImage,
                fit: BoxFit.cover, height: height, width: width)
            .cornerRadiusWithClipRRect(defaultRadius);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorderWidget(
          padding: const EdgeInsets.all(1),
          radius: defaultRadius,
          color: AppPalette.primaryColor,
          dotsWidth: 10,
          strokeWidth: 1.5,
          child: GestureDetector(
            onTap: () async {
              FileTypes file = await showInDialog(
                context,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                title: Text(context.localizations!.chooseAnAction,
                    style: boldTextStyle()),
                builder: (p0) {
                  return FilePickerDialog(
                      isSelected: (isUpdate || image != null));
                },
              );
              if (file == FileTypes.CANCEL) {
                image = null;
                widget.defaultImage = null;
                isUpdate = false;

                if (widget.isRes) {
                  // await deleteImage(request).then((value) {
                  //   image = null;
                  //   widget.defaultImage = null;
                  //   isUpdate = false;
                  //   setState(() {});
                  // }).catchError((e) {});
                } else {
                  // await deleteImage(request).then((value) {
                  //   image = null;
                  //   widget.defaultImage = null;
                  //   isUpdate = false;
                  //   setState(() {});
                  // }).catchError((e) {});
                }
              } else {
                image = await getImageSource(
                    isCamera: file == FileTypes.CAMERA ? true : false);
                widget.onImageSelected.call(image!);
                setState(() {});
              }
            },
            child: Container(
              height: 200,
              width: widget.width ?? context.width(),
              decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: radius(defaultRadius)),
              child: getImagePlatform(height: 180, width: context.width()),
            ),
          ),
        ),
        8.height,
        Text(context.localizations!.imageSupport,
            style: primaryTextStyle(color: AppPalette.bodyColor, size: 12)),
      ],
    );
  }
}

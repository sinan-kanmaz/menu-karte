import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/core/utils/common.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static String routeName = "/edit-profile";

  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController numCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  FocusNode contactFocus = FocusNode();

  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    final user = ref.read(authStateProvider);

    if (user != null) {
      nameCont.text = user.displayName.toString();
      emailCont.text = user.email!;
      numCont.text = user.phoneNumber.toString();

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return Scaffold(
      appBar: appBarWidget(
        context.localizations!.editProfile,
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        titleTextStyle: boldTextStyle(
            size: 18,
            color: context.theme.brightness == Brightness.dark
                ? Colors.white
                : AppPalette.headingColor),
        backWidget: IconButton(
          onPressed: () {
            finish(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
                thickness: 1,
                color: context.dividerColor,
                indent: 16,
                endIndent: 16),
            20.height,
            Stack(
              children: [
                pickedFile != null
                    ? Image.network(
                        pickedFile!.path,
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(70)
                    : cachedImage(
                        user.photoURL,
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(70),
                Positioned(
                  bottom: 8,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: AppPalette.primaryColor,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Image.asset('assets/images/ic_Camera.png',
                        height: 20, width: 20, fit: BoxFit.cover, color: white),
                  ).onTap(() async {
                    _showBottomSheet(context);
                  }),
                ).visible(true)
              ],
            ),
            16.height,
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: radius(defaultRadius)),
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.localizations!.enterYourProfileDetails,
                        style: context.appTheme.appTextTheme.boldTextStyle),
                    18.height,
                    AppTextField(
                      textInputAction: TextInputAction.next,
                      controller: nameCont,
                      nextFocus: contactFocus,
                      textFieldType: TextFieldType.NAME,
                      textStyle: secondaryTextStyle(),
                      decoration: inputDecoration(context,
                              label: context.localizations!.name)
                          .copyWith(
                        prefixIcon: Image.asset('assets/images/ic_User.png',
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                                color: AppPalette.bodyColor)
                            .paddingAll(12),
                      ),
                    ),
                    16.height,
                    AppTextField(
                      textInputAction: TextInputAction.done,
                      controller: emailCont,
                      readOnly: true,
                      textFieldType: TextFieldType.EMAIL,
                      enabled: true,
                      textStyle: secondaryTextStyle(),
                      decoration: inputDecoration(context,
                              label: context.localizations!.emailAddress)
                          .copyWith(
                        prefixIcon: Image.asset('assets/images/ic_Message.png',
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                                color: AppPalette.bodyColor)
                            .paddingAll(12),
                      ),
                    ),
                    16.height,
                    AppTextField(
                      textInputAction: TextInputAction.done,
                      controller: numCont,
                      focus: contactFocus,
                      maxLength: 12,
                      textFieldType: TextFieldType.PHONE,
                      textStyle: secondaryTextStyle(),
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) =>
                          null,
                      decoration: inputDecoration(context,
                              label: context.localizations!.number)
                          .copyWith(
                        prefixIcon: Image.asset('assets/images/ic_Phone.png',
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                                color: AppPalette.bodyColor)
                            .paddingAll(12),
                      ),
                    ),
                    32.height,
                  ],
                ),
              ),
            ),
          ],
        ),
      ).visible(true, defaultWidget: Loader()),
      bottomNavigationBar: AppButton(
        text: context.localizations!.save.toUpperCase(),
        textStyle: boldTextStyle(color: Colors.white, size: 18),
        margin: const EdgeInsets.all(16),
        elevation: 0,
        color: AppPalette.primaryColor,
        enabled: true,
        shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
        onTap: () {
          showConfirmDialogCustom(
            context,
            dialogType: DialogType.UPDATE,
            title: context.localizations!.doYouWantToUpdateProfile,
            onAccept: (context) async {
              hideKeyboard(context);
              await updateProfile();
            },
          );
        },
      ).visible(true),
    );
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {});
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {});
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: context.localizations!.gallery,
              leading: const Icon(Icons.image, color: AppPalette.primaryColor),
              onTap: () {
                _getFromGallery();
                finish(context);
              },
            ),
            const Divider(),
            SettingItemWidget(
              title: context.localizations!.camera,
              leading: const Icon(Icons.camera, color: AppPalette.primaryColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  Future<void> updateProfile() async {
    ref
        .read(authStateProvider.notifier)
        .updateProfile(nameCont.text, numCont.text, pickedFile?.path);
  }
}

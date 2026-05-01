import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/global_providers/auth_state_provider.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/cached_network_image.dart';
import 'package:qrmenu/screens/edit_profile_screen.dart';

class EditProfileCard extends ConsumerWidget {
  const EditProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: context.cardColor, borderRadius: radius(defaultRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cachedImage(user!.photoURL,
                      height: 50, width: 50, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(70),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName.toString(),
                    style: boldTextStyle(
                        size: 18,
                        color: context.theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppPalette.headingColor),
                  ),
                  Text(user.email.toString(),
                      style: secondaryTextStyle(color: AppPalette.bodyColor)),
                ],
              )
            ],
          ),
          Image.asset('assets/images/ic_Edit.png', height: 30).onTap(() {
            const EditProfileScreen().launch(context);
            // context.go(EditProfileScreen.routeName);
            // push(EditProfileScreen(),
            //     pageRouteAnimation: PageRouteAnimation.Slide);
          }),
        ],
      ),
    );
  }
}

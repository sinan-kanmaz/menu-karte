import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/global_providers/user_state_provider.dart';
import 'package:qrmenu/core/models/restaurant/menu_tab.dart';
import 'package:qrmenu/core/theme/app_palette.dart';

class MenuTabs extends ConsumerWidget {
  const MenuTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: context.iconColor,
        title: Text(context.localizations!.menuTabs),
      ),
      body: user.menuTabs != null
          ? ListView.builder(
              itemCount: user.menuTabs!.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                    user.menuTabs![index]
                        .getLacalName(context.localizations!.localeName),
                    style: context.appTheme.appTextTheme.boldTextStyle),
                trailing: IconButton(
                  onPressed: () {
                    // ref
                    //     .read(userStateProvider.notifier)
                    //     .removeMenuTab(user.menuTabs![index]);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppPalette.primaryColor,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String? en;
          String? de;
          String? nl;
          String? fr;
          String? tr;
          showDialog(
            context: context,
            builder: (context) => Material(
              child: AlertDialog.adaptive(
                title: const Text('New Tab'),
                content: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "en",
                        labelStyle: secondaryTextStyle(),
                      ),
                      onChanged: (v) {
                        en = v;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "de",
                        labelStyle: secondaryTextStyle(),
                      ),
                      onChanged: (v) {
                        de = v;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "nl",
                        labelStyle: secondaryTextStyle(),
                      ),
                      onChanged: (v) {
                        nl = v;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "fr",
                        labelStyle: secondaryTextStyle(),
                      ),
                      onChanged: (v) {
                        fr = v;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "tr",
                        labelStyle: secondaryTextStyle(),
                      ),
                      onChanged: (v) {
                        tr = v;
                      },
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (context.mounted) finish(context);
                    },
                    child: Text(context.localizations!.cancel.toUpperCase()),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (en != null &&
                          de != null &&
                          nl != null &&
                          fr != null &&
                          tr != null) {
                        MenuTab tab = MenuTab(en: en, de: de, nl: nl, tr: tr);
                        await ref
                            .read(userStateProvider.notifier)
                            .addNewTab(tab);
                      }
                      if (context.mounted) finish(context);
                    },
                    child: Text(context.localizations!.save.toUpperCase()),
                  )
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

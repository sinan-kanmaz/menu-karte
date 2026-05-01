import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qrmenu/core/models/category.dart';
import 'package:qrmenu/core/models/menu/menu.dart';
import 'package:qrmenu/screens/add_category_screen.dart';
import 'package:qrmenu/screens/edit_profile_screen.dart';
import 'package:qrmenu/screens/email_verify_screen.dart';
import 'package:qrmenu/screens/dashboard_screen/dashboard_screen.dart';
import 'package:qrmenu/screens/new_menu_screen/add_menu_item_creen.dart';
import 'package:qrmenu/screens/qr_generate_screen/qr_generate_screen.dart';
import 'package:qrmenu/screens/restaurant_screen/restaurant_screen.dart';
import 'package:qrmenu/screens/settings_screen/setting_screen.dart';
import 'package:qrmenu/screens/sign_in_screen/sign_in_screen.dart';

import 'global_providers/auth_state_provider.dart';

final GlobalKey<NavigatorState> rootNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'Main Navigator');
final GlobalKey<NavigatorState> shellNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'Shell Navigator');

final goRouterProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
      refreshListenable: router,
      routes: router._routes,
      navigatorKey: rootNavigator,
      initialLocation: '/');
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  User? user;

  RouterNotifier(this._ref) {
    _ref.listen<User?>(
      authStateProvider,
      (previus, next) {
        user = next;

        notifyListeners();
      },
    );
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: SignInScreen.routeName,
          parentNavigatorKey: rootNavigator,
          builder: (context, state) => const SignInScreen(),
          redirect: (context, state) {
            if (user == null) {
              return null;
            } else {
              if (user!.emailVerified) {
                return "/";
              } else {
                return EmailVerifyScreen.routeName;
              }
            }
          },
        ),
        GoRoute(
          path: AddCategoryScreen.routeName,
          parentNavigatorKey: rootNavigator,
          builder: (context, state) {
            MenuCategory? category = state.extra as MenuCategory?;
            return AddCategoryScreen(
              category: category,
            );
          },
          redirect: (context, state) {
            if (user != null) {
              return null;
            } else {
              if (user!.emailVerified) {
                return "/";
              } else {
                return EmailVerifyScreen.routeName;
              }
            }
          },
        ),
        GoRoute(
          path: AddMenuItemScreen.routeName,
          parentNavigatorKey: rootNavigator,
          builder: (context, state) {
            Menu? menu = state.extra as Menu?;
            return AddMenuItemScreen(menu: menu);
          },
          redirect: (context, state) {
            if (user != null) {
              if (user!.emailVerified) {
                return null;
              } else {
                return EmailVerifyScreen.routeName;
              }
            } else {
              return SignInScreen.routeName;
            }
          },
        ),
        GoRoute(
          path: SettingScreen.routeName,
          parentNavigatorKey: rootNavigator,
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          path: QrGenerateScreen.routeName,
          parentNavigatorKey: rootNavigator,
          builder: (context, state) => const QrGenerateScreen(),
          redirect: (context, state) {
            if (user != null) {
              if (user!.emailVerified) {
                return null;
              } else {
                return EmailVerifyScreen.routeName;
              }
            } else {
              return SignInScreen.routeName;
            }
          },
        ),
        GoRoute(
          path: "/:restaurantId",
          parentNavigatorKey: rootNavigator,
          builder: (context, state) {
            return RestaurantDetailScreen(
              restaurantId: state.pathParameters['restaurantId'].toString(),
            );
          },
        ),
        GoRoute(
          path: EditProfileScreen.routeName,
          parentNavigatorKey: rootNavigator,
          builder: (context, state) => const EditProfileScreen(),
          redirect: (context, state) {
            if (user != null) {
              return null;
            } else {
              if (user!.emailVerified) {
                return "/";
              } else {
                return EmailVerifyScreen.routeName;
              }
            }
          },
        ),
        ShellRoute(
          navigatorKey: shellNavigator,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return const DashboardScreen();
          },
          routes: [
            GoRoute(
                path: '/',
                parentNavigatorKey: shellNavigator,
                builder: (context, state) => const DashboardScreen(),
                redirect: (context, state) {
                  if (user == null) {
                    return SignInScreen.routeName;
                  } else {
                    if (!user!.emailVerified) {
                      return EmailVerifyScreen.routeName;
                    } else {
                      return null;
                    }
                  }
                }),
          ],
        ),
      ];
}

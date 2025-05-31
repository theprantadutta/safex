import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safex/screens/insights_screen.dart';
import 'package:safex/screens/profile_screen.dart';
import 'package:safex/screens/transfer_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../main.dart';
import '../screens/home_screen.dart';
import 'bottom_navgation_layout.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = HomeScreen.kRouteName;

  // Private navigators
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );
  static final _shellNavigatorTransfers = GlobalKey<NavigatorState>(
    debugLabel: 'shellTransfers',
  );
  static final _shellNavigatorInsights = GlobalKey<NavigatorState>(
    debugLabel: 'shellInsights',
  );
  static final _shellNavigatorProfile = GlobalKey<NavigatorState>(
    debugLabel: 'shellProfile',
  );

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    observers: [TalkerRouteObserver(talker!)],
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    routes: [
      /// LoginScreen Route
      // GoRoute(
      //   parentNavigatorKey: rootNavigatorKey,
      //   path: LoginScreen.kRouteName,
      //   name: "Login",
      //   builder: (context, state) => LoginScreen(
      //     key: state.pageKey,
      //   ),
      //   redirect: (context, state) async {
      //     final currentUser = await DriftZakatUserService.getCurrentUser();
      //     final currentZakatApplication =
      //         await DriftZakatApplicationService.getCurrentZakatApplication();
      //     if (currentUser == null || currentZakatApplication == null) {
      //       return null;
      //     }
      //     getIt<UserService>()
      //         .setCurrentUser(ModifiedUser.fromZakatUser(currentUser));
      //     getIt<ZakatApplicationService>()
      //         .setCurrentZakatApplication(currentZakatApplication);
      //     return HomeScreen.kRouteName;
      //   },
      // ),

      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigationLayout();
        },
        branches: <StatefulShellBranch>[
          /// Branch Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: HomeScreen.kRouteName,
                name: "Home",
                // builder: (BuildContext context, GoRouterState state) =>
                //     const HomeScreen(),
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorTransfers,
            routes: <RouteBase>[
              GoRoute(
                path: TransferScreen.kRouteName,
                name: "Transfers",
                // builder: (BuildContext context, GoRouterState state) =>
                //     const AttendanceScreen(),
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const TransferScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorInsights,
            routes: <RouteBase>[
              GoRoute(
                path: InsightsScreen.kRouteName,
                name: "Insights",
                // builder: (BuildContext context, GoRouterState state) =>
                //     const LeaveScreen(),
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const InsightsScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: ProfileScreen.kRouteName,
                name: "Profile",
                // builder: (BuildContext context, GoRouterState state) =>
                //     const ServicesScreen(),
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      /// Check Net Speed Route
      // GoRoute(
      //   parentNavigatorKey: rootNavigatorKey,
      //   path: CheckNetSpeedScreen.kRouteName,
      //   name: "Check Net Speed",
      //   builder: (context, state) => CheckNetSpeedScreen(key: state.pageKey),
      // ),
    ],
  );

  static CustomTransitionPage<void> reusableTransitionPage({
    required state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      restorationId: state.pageKey.value,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

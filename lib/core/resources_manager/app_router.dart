import 'package:call_son/feature/guardian_history/presentation/views/history_view.dart';
import 'package:call_son/feature/auth/presentation/views/parent_register_view.dart';
import 'package:call_son/feature/school/presentation/views/school_calls_view.dart';
import 'package:call_son/feature/school/presentation/views/school_guardian_view.dart';
import 'package:call_son/feature/school/presentation/views/school_home_layout.dart';
import 'package:call_son/feature/auth/presentation/views/location_view.dart';
import 'package:call_son/feature/splash/presentation/views/splash_view.dart';
import 'package:call_son/feature/welcome/presentation/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/guardian/presentation/views/call_view.dart';

abstract class AppRouter {
  static Widget? widget;
  static const kHomeView = '/homeView';
  static const kLocationView = '/locationView';
  static const kCallView = '/callView';
  static const kRegTypeView = '/regTypeView';
  static const kGuardianVerifyView = '/guardianVerifyView';
  static const kSchoolVerifyView = '/guardianVerifyView';
  static const kSchoolRegView = '/schoolRegView';
  static const kGradiantRegView = '/gradiantRegView';
  static const kSchoolHomeView = '/schoolHomeView';
  static const kSchoolGuardiansView = '/schoolGuardiansView';
  static const kSchoolCallsView = '/schoolCallsView';
  static const kGuardianHistoryView = '/guardianHistoryView';
  static const kGuardianResultView = '/guardianResultView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kLocationView,
        builder: (context, state) => const LocationView(),
      ),
      GoRoute(
        path: kCallView,
        builder: (context, state) => const CallView(),
      ),
      GoRoute(
        path: kRegTypeView,
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: kGradiantRegView,
        builder: (context, state) => const ParentRegisterView(),
      ),
      GoRoute(
        path: kSchoolHomeView,
        builder: (context, state) => const SchoolHomeLayout(),
      ),
      GoRoute(
        path: kSchoolGuardiansView,
        builder: (context, state) => const SchoolGuardiansView(),
      ),
      GoRoute(
        path: kSchoolCallsView,
        builder: (context, state) => const SchoolCallsView(),
      ),
      GoRoute(
        path: kGuardianHistoryView,
        builder: (context, state) => const GuardianHistoryView(),
      ),
      // GoRoute(
      //   path: kGuardianResultView,
      //   builder: (context, state) => const ResultView(),
      // ),
    ],
  );
}

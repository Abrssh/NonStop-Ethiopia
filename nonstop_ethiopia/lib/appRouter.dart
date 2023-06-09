import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nonstop_ethiopia/SecondUi.dart';
import 'package:nonstop_ethiopia/signInPage.dart';

class AppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      path: "/",
      pageBuilder: (context, state) {
        return MaterialPage(child: SignInPage());
      },
    ),
    GoRoute(
      path: "/secondPage",
      pageBuilder: (context, state) {
        return MaterialPage(child: SecondHomePage());
      },
    )
  ]);
}

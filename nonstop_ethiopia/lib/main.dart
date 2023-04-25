// @dart=2.9
import 'package:flutter/material.dart';
import 'package:nonstop_ethiopia/Provider/counter_provider.dart';
import 'package:nonstop_ethiopia/appRouter.dart';
// import 'package:nonstop_ethiopia/signInPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FirstProvider())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Non Stop Ethiopia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: AppRouter().router.routeInformationParser,
      routerDelegate: AppRouter().router.routerDelegate,
      // home: SignInPage(),
    );
  }
}

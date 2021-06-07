import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:not_gatew/screens/splash_screen.dart';

import 'colours.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'not_gate',
      theme: ThemeData.dark().copyWith(
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.white, selectionHandleColor: Colors.white),
          textTheme: TextTheme(bodyText2: TextStyle(color: Constants.white))),
      home: SplashScreen(),
    );
  }
}

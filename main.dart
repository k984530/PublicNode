import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node/core/purchase/purchase.dart';
import 'package:node/firebase_options.dart';
import 'package:node/function/login.dart';
import 'package:node/home/router.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/informations/info.dart';
import 'package:node/ui/page/loginSignup.dart';
import 'package:node/ui/page/menu.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/splash/splash_page.dart';
import 'package:node/ui/page/teams/mainTeamPage.dart';
import 'home/root.dart';

String AppleLoginName = '';
bool AppleLoginbool = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//  await initPlatformState();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Node Idea',
      theme: ThemeData(
        fontFamily: 'IBM',
        scaffoldBackgroundColor: Colors.blue.shade50,
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent.shade700,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.75),
            fontSize: 15,
          ),
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: splashPage.route,
      onGenerateRoute: AppRouter.onNavigate,
    );
  }
}

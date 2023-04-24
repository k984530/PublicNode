import 'package:flutter/material.dart';
import 'package:node/ui/page/loginSignup.dart';
import 'package:node/ui/page/menu.dart';
import 'package:node/ui/page/splash/splash_page.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  static const String route = '/root';
  @override
  Widget build(BuildContext context) {
    return mainLogin();
  }
}

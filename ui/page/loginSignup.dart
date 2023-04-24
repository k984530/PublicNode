import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/main.dart';

import 'package:node/ui/page/menu.dart';
import '../../function/login.dart';

class mainLogin extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final styles = theme.textTheme;
    return Scaffold(
      backgroundColor: Color(0xFF9FA8DA),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const menuPage();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "NODE",
                        style: styles.displayMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            BoxShadow(
                              color: Colors.blue.shade600,
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(3, 5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 170,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SignInButton(
                                Buttons.GoogleDark,
                                text: '구글 로그인',
                                onPressed: () async {
                                  try {
                                    AppleLoginbool = false;
                                    await login().signInWithGoogle();
                                  } catch (e) {}
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if (Platform.isIOS)
                                SignInButton(
                                  Buttons.AppleDark,
                                  text: 'Apple 로그인',
                                  onPressed: () async {
                                    try {
                                      AppleLoginbool = false;
                                      await login().signInwithApple();
                                    } catch (e) {}
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

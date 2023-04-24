import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/main.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class login {
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
    } else {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<void> signInwithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      AppleLoginbool = true;

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      if (appleCredential.givenName != null) {
        AppleLoginName = (appleCredential.familyName as String) +
            (appleCredential.givenName as String);
      }
    } catch (e) {
      print(e);
    }
  }
}

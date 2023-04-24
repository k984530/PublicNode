import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/home/root.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';

import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/informations/adminMessage.dart';
import 'package:node/ui/page/informations/adminReport.dart';
import 'package:node/ui/page/messages/mainMessagePage.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

class MyDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(accountRepositoryProvider).id;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Drawer(
            backgroundColor: Colors.lightBlue.shade50,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 24 + MediaQuery.of(context).padding.top,
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(color: Colors.cyanAccent.shade700),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        snapshot.data!.get('name'),
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data!.get('classes').toString(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Consumer(builder: (context, ref, child) {
                  final model = ref.watch(writeAccountViewModelProvider);
                  final me = ref.read(accountRepositoryProvider).me;
                  final myClass = ref.read(accountRepositoryProvider).myClass;
                  return Container(
                    padding: EdgeInsets.all(24),
                    child: Wrap(
                      runSpacing: 16,
                      children: [
                        if (myClass == 'ADMIN')
                          ListTile(
                            leading: Icon(
                              Icons.feedback,
                              color: Colors.grey[850],
                            ),
                            title: Text('신고함'),
                            onTap: () async {
                              Navigator.of(context)
                                  .pushNamed(adminReportPage.route);
                            },
                          ),
                        if (myClass == 'ADMIN')
                          ListTile(
                            leading: Icon(
                              Icons.mail_outline_sharp,
                              color: Colors.grey[850],
                            ),
                            title: Text('지원자'),
                            onTap: () async {
                              Navigator.of(context)
                                  .pushNamed(adminMessagePage.route);
                            },
                          ),
                        ListTile(
                          leading: Icon(
                            Icons.mail_outline_sharp,
                            color: Colors.grey[850],
                          ),
                          title: Text('편지함'),
                          onTap: () async {
                            Navigator.of(context).pushNamed(messagePage.route);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: Colors.grey[850],
                          ),
                          title: Text('사용자 설정'),
                          onTap: () async {
                            await model.setAccount(me!.id as String);
                            Navigator.of(context)
                                .pushNamed(accountSettingPage.route);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.coffee_outlined,
                            color: Colors.grey[850],
                          ),
                          title: Text('커피 한 잔 보내기'),
                          onTap: () async {
                            // await Purchases.purchaseProduct(
                            //   'node_donate',
                            //   type: PurchaseType.inapp,
                            // );
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                content: const Text(
                                  "감사합니다 하지만 마음만 받을게요 :)",
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.feedback,
                            color: Colors.grey[850],
                          ),
                          title: Text('차단한 계정 풀기'),
                          onTap: () async {
                            await ref
                                .read(accountRepositoryProvider)
                                .releaseAccount();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                content: const Text(
                                  "야호~ 석방이다 감사합니다!",
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.logout_sharp,
                            color: Colors.grey[850],
                          ),
                          title: Text('로그아웃'),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            GoogleSignIn().signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Root.route, (route) => false);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        });
  }
}

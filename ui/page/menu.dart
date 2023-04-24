import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';

import 'package:node/ui/page/drawer.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/informations/eula.dart';
import 'package:node/ui/page/informations/goldInfo.dart';
import 'package:node/ui/page/informations/info.dart';
import 'package:node/ui/page/teams/mainTeamPage.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

class menuPage extends ConsumerWidget {
  const menuPage({Key? key}) : super(key: key);
  static const String route = '/menu';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountRepositoryProvider);
    ref.watch(messageRepositoryProvider);
    final init = ref.watch(accountInitiate(context));
    final shadow = [
      BoxShadow(
        color: Colors.blue.shade600,
        blurRadius: 5,
        spreadRadius: 2,
        offset: Offset(3, 5),
      ),
    ];

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final messages = ref.watch(messagesProvider);
            String state = '';
            messages.when(
              data: (data) {
                for (var m in data) {
                  if (m.read as bool == false) {
                    state = '아직 읽지 않은 메시지가 있습니다.';
                    break;
                  }
                }
                return Text(
                  state,
                  style: TextStyle(fontSize: 11),
                );
              },
              loading: (() => Text(state)),
              error: (((error, stackTrace) => Text(state))),
            );
            return Text(
              state,
              style: TextStyle(fontSize: 11),
            );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.2,
                0.5,
                0.8,
                0.7
              ],
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
                Colors.blue.shade200,
                Colors.blue.shade300,
              ]),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NODE',
                    style: TextStyle(
                      color: Colors.cyan.shade600.withOpacity(0.8),
                      fontSize: 80,
                      shadows: shadow,
                    ),
                  ),
                  Text(
                    '- 아이디어 -',
                    style: TextStyle(
                      color: Colors.cyan.shade500,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            init.when(data: (data) {
              return Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(ideaPage.route);
                        },
                        child: Container(
                          width: 250,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.indigoAccent.shade200,
                            boxShadow: shadow,
                          ),
                          child: Text(
                            '아이디어',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(teamPage.route);
                        },
                        child: Container(
                          width: 250,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.indigoAccent.shade200,
                            boxShadow: shadow,
                          ),
                          child: Text(
                            '팀',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // if (account.myClass == 'GUEST')
                      //   GestureDetector(
                      //     onTap: () async {
                      //       try {
                      //         await Purchases.purchaseProduct(
                      //             'node_membership_gold',
                      //             type: PurchaseType.inapp);
                      //         await account
                      //             .buyMembership(account.me as Account);
                      //         ScaffoldMessenger.of(context)
                      //             .hideCurrentSnackBar();
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(
                      //             duration: Duration(seconds: 2),
                      //             content: const Text(
                      //               "회원권 구매 성공",
                      //             ),
                      //           ),
                      //         );
                      //         Navigator.of(context)
                      //             .pushReplacementNamed(menuPage.route);
                      //       } catch (e) {
                      //         ScaffoldMessenger.of(context)
                      //             .hideCurrentSnackBar();
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(
                      //             duration: Duration(seconds: 2),
                      //             content: const Text(
                      //               "회원권 구매 실패",
                      //             ),
                      //           ),
                      //         );
                      //       }
                      //     },
                      //     child: Container(
                      //       width: 250,
                      //       height: 80,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: Colors.indigoAccent.shade200,
                      //         boxShadow: shadow,
                      //       ),
                      //       child: Text(
                      //         '회원권 구매',
                      //         style: TextStyle(
                      //           fontSize: 32,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white.withOpacity(0.95),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      if (account.myClass == 'YONSEI' ||
                          account.myClass == 'ADMIN')
                        GestureDetector(
                          onTap: () async {
                            await ref.read(messageRepositoryProvider).notify();
                            Navigator.of(context)
                                .pushNamed(sendApplyPage.route);
                          },
                          child: Container(
                            width: 250,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.indigoAccent.shade200,
                              boxShadow: shadow,
                            ),
                            child: Text(
                              'NODE',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ),
                        ),
                      if (account.myClass == 'GOLD')
                        GestureDetector(
                          onTap: () async {
                            await ref.read(messageRepositoryProvider).notify();
                            Navigator.of(context).pushNamed(goldInfoPage.route);
                          },
                          child: Container(
                            width: 250,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.indigoAccent.shade200,
                              boxShadow: shadow,
                            ),
                            child: Text(
                              'NODE',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }, error: (Object error, StackTrace stackTrace) {
              return Center(
                child: Text(error.toString()),
              );
            }, loading: () {
              return SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}

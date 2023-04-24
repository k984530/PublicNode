import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/informations/notice.dart';
import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';

class goldInfoPage extends ConsumerWidget {
  const goldInfoPage({super.key});
  static const String route = '/goldInfo';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 2.0,
        spreadRadius: 2.0,
        offset: Offset(2, 5),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('NODE'),
        centerTitle: true,
        actions: [
          if (ref.read(accountRepositoryProvider).myClass == 'ADMIN')
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(editNoticePage.route);
              },
              icon: Icon(Icons.edit),
            ),
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: s,
          ),
          child: Text(
            '''안녕하세요 Node 입니다.
Node는 연세대학교 미래캠퍼스 소속
창업 및 앱 개발 동아리입니다.
Node는 앱 개발 외에도 교내 학우들을 대상으로
flutter 세미나를 진행하여 앱 개발 능력을 함양시키거나,
디자이너, 경영, 타 전공 등 다양한 사람들이 모여서
지식을 교류하는 활동으로 운영하는 동아리 입니다.
앞으로도 많은 활동들을 기대해주세요.
감사합니다.''',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

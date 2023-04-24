import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';

import 'package:node/models/account.dart';
import 'package:node/models/report.dart';

import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';

import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';
import 'package:node/ui/page/messages/sendMessage.dart';
import 'package:node/ui/page/teams/mainTeamPage.dart';
import 'package:node/ui/page/teams/provider/toggle.dart';
import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';
import 'package:node/ui/page/teams/teamSetting.dart';

class explainTeam extends ConsumerWidget {
  static const String route = '/explainTeam';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final C = Colors.cyan.shade100;
    final model = ref.watch(writeTeamViewModelProvider);
    final account = ref.watch(writeAccountViewModelProvider);
    final user = ref.read(accountRepositoryProvider);
    final myClass = user.me!.classes;
    final fieldToggle = ref.watch(fieldToggleProvider);
    bool isMe = model.initial.userID == user.id;

    return Scaffold(
      bottomNavigationBar: !isMe && model.state
          ? SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: (() {
                  if (model.enable) {
                    ref
                        .read(writeMessageViewModelProvider)
                        .init(user.me as Account, model.initial.name);
                    Navigator.of(context).pushNamed(sendMessagePage.route);
                  }
                }),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: Colors.blueAccent.shade700,
                  ),
                  child: Text(
                    '함께 하기',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        centerTitle: true,
        title: Text(model.name),
        actions: [
          if (isMe || myClass == 'ADMIN')
            GestureDetector(
              onTap: () {
                fieldToggle.selectedFields = model.fieldList();
                Navigator.of(context).pushNamed(teamSettingPage.route);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.edit,
                ),
              ),
            ),
          if (!(isMe || myClass == 'ADMIN'))
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('해당 게시글이 불쾌한 콘텐츠를 포함하고 있습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(accountRepositoryProvider)
                                  .banAccount(model.initial.userID as String);
                            } catch (e) {
                              print(e);
                            }
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pushReplacementNamed(teamPage.route);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                content: const Text(
                                  "작성자를 처리했습니다.",
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            '작성자 차단하기',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(messageRepositoryProvider)
                                    .sendReport(
                                      Report(
                                        title: model.name,
                                        contentID: model.initial.ideaID +
                                            model.initial.userID,
                                        type: 'team',
                                      ),
                                    );
                              } catch (e) {
                                print(e);
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('네')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('아니요'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.feedback,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: C,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.indigo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              '팀명',
                            ),
                            Spacer(),
                            Text(
                              model.name,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            '모집 분야 : ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(10),
                            constraints: const BoxConstraints(
                              minHeight: 30,
                              minWidth: 50,
                            ),
                            borderColor: Colors.blue.shade200,
                            selectedBorderColor: Colors.blue.shade700,
                            selectedColor: Colors.white,
                            fillColor: Colors.blue.shade200,
                            color: Colors.blue.shade400,
                            onPressed: (int i) {},
                            children: fieldToggle.fields,
                            isSelected: [
                              model.fields['plan'] as bool,
                              model.fields['develop'] as bool,
                              model.fields['design'] as bool,
                              model.fields['marketting'] as bool,
                              model.fields['etc'] as bool,
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.topCenter,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        decoration: BoxDecoration(
                          color: C,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.indigo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '팀 소개 & 모집 상세',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(model.content),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        decoration: BoxDecoration(
                          color: C,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.indigo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              '아이디어',
                            ),
                            Spacer(),
                            Text(
                              model.initial.ideaName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.topCenter,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        decoration: BoxDecoration(
                          color: C,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.indigo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '아이디어 소개',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(model.initial.ideaContent),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            '모집 상태 : ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            width: 80,
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: model.state
                                    ? Colors.blue
                                    : Colors.blue.shade200,
                              ),
                              color: model.state ? Colors.blue.shade200 : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              model.state ? '모집 중' : '모집 끝',
                              style: TextStyle(
                                  color: model.state
                                      ? Colors.white
                                      : Colors.blue.shade400),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                          color: C,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.indigo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text('팀장'),
                            Spacer(),
                            Text(
                              account.name,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.topCenter,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                          color: C,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.indigo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '팀장 소개',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              account.content,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/teams_database.dart';
import 'package:node/function/filter.dart';
import 'package:node/models/team.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';
import 'package:node/ui/page/teams/provider/toggle.dart';
import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';

final recruitState = Provider.autoDispose<bool>((ref) => true);

class teamSettingPage extends ConsumerWidget {
  const teamSettingPage({super.key});

  static const String route = '/teamSetting';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(writeTeamViewModelProvider);
    final fieldToggle = ref.watch(fieldToggleProvider);
    final user = ref.read(accountRepositoryProvider).id;
    final myClass = ref.read(accountRepositoryProvider).myClass;
    bool isMe = model.initial.userID == user;
    final fb = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    );
    final eb = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blue.shade200, width: 2.0),
    );
    final fc = Colors.cyan.shade100.withOpacity(0.8);
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: GestureDetector(
          onTap: (() async {
            if (model.enable) {
              if (Contentfilter.filterContent(model.content) ||
                  Contentfilter.filterContent(model.name)) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text(
                      "비속어가 포함되어 있습니다. 수정해주세요",
                    ),
                  ),
                );
              } else {
                model.setfields(fieldToggle.selectedFields);
                model.initial = model.initial.copyWith(userID: user);
                await model.write();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text(
                      "팀을 성공적으로 저장했습니다",
                    ),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: const Text(
                    "빈 칸 없이 모두 기입해주세요",
                  ),
                ),
              );
            }
          }),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.blueAccent.shade700.withOpacity(0.9),
            ),
            child: Text(
              '저장하기',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('팀 설정'),
        actions: [
          if (myClass == 'ADMIN')
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('해당 사용자에게 제재를 가하시겠습니까?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              final thisAccount = await ref
                                  .read(accountRepositoryProvider)
                                  .returnThisAccount(model.initial.userID);
                              ref
                                  .read(accountRepositoryProvider)
                                  .punishAccount(thisAccount);
                              Navigator.of(context)
                                ..pop()
                                ..pop()
                                ..pop();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: const Text(
                                    "해당 유저를 처리했습니다.",
                                  ),
                                ),
                              );
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
                  Icons.block,
                ),
              ),
            ),
          if (isMe && model.edit || myClass == 'ADMIN' && model.edit)
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('해당 게시글을 삭제하시겠습니까? \n삭제된 게시글은 복원할 수 없습니다.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              ref
                                  .read(teamRepositoryProvider)
                                  .delete(model.initial.id);
                              Navigator.of(context)
                                ..pop()
                                ..pop()
                                ..pop();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: const Text(
                                    "팀을 성공적으로 삭제했습니다",
                                  ),
                                ),
                              );
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
                  Icons.delete,
                ),
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextFormField(
                            initialValue:
                                model.edit ? model.initial.name : null,
                            maxLength: 13,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              label: Text('팀명'),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'ex) NODE',
                              focusedBorder: fb,
                              enabledBorder: eb,
                              filled: true,
                              fillColor: fc,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (v) => model.name = v,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: Text(
                            '아이디어 : ${model.initial.ideaName}',
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              '모집 분야 : ',
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ToggleButtons(
                              borderRadius: BorderRadius.circular(10),
                              constraints: const BoxConstraints(
                                minHeight: 35,
                                minWidth: 50,
                              ),
                              borderColor: Colors.blue.shade200,
                              selectedBorderColor: Colors.blue.shade700,
                              selectedColor: Colors.white,
                              fillColor: Colors.blue.shade200,
                              color: Colors.blue.shade400,
                              onPressed: (int i) {
                                fieldToggle.changeState(i);
                              },
                              children: fieldToggle.fields,
                              isSelected: fieldToggle.selectedFields,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: TextFormField(
                            initialValue:
                                model.edit ? model.initial.content : null,
                            maxLines: 12,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              label: Text(
                                '팀 설명 & 모집 상세',
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: fb,
                              enabledBorder: eb,
                              filled: true,
                              fillColor: fc,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText:
                                  '팀과 모집 분야에 대한 상세 설명을 적어주세요. 양식은 자유롭게 적으시면 됩니다.\n ex) 앱 개발 출시를 목표로 준비합니다. 주 1회 회의를 하며 진행 상황과 앞으로의 방향성을 잡아갑니다.  \n OO공모전을 목표로 준비하고 있습니다. 환경에 관심이 많으신 분들이나, 공모전 경험을 쌓아보고 싶으신 분들 모두 환영합니다. 많은 관심 바랍니다.\n개발 - 서버 및 데이터베이스 구축\n디자인 - 앱 로고와 아이콘 제작 \n...등등',
                            ),
                            onChanged: (v) => model.content = v,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text('모집 상태 : '),
                            GestureDetector(
                              onTap: (() => model.changeState()),
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: model.state
                                        ? Colors.blue
                                        : Colors.blue.shade200,
                                  ),
                                  color:
                                      model.state ? Colors.blue.shade200 : null,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

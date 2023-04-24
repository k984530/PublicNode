import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/ideas_database.dart';
import 'package:node/function/filter.dart';
import 'package:node/function/filterWord.dart';
import 'package:node/models/idea.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';

class createIdea extends ConsumerWidget {
  static const String route = '/createIdea';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(writeIdeaViewModelProvider);
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
          onTap: () async {
            if (model.enable) {
              try {
                if (Contentfilter.filterContent(model.title) ||
                    Contentfilter.filterContent(model.content)) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: const Text(
                        "비속어가 포함 되어있습니다 수정해주세요.",
                      ),
                    ),
                  );
                } else {
                  await model.write();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: const Text(
                        "아이디어를 성공적으로 저장했습니다!",
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
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
          },
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
        title: Text('아이디어'),
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
                                  .returnThisAccount(
                                      model.initial.userID as String);
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
                              ref.read(ideaRepositoryProvider).delete(model.id);
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
                                    "아이디어를 성공적으로 삭제했습니다.",
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
        child: Column(
          children: [
            Expanded(
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        child: TextFormField(
                          initialValue: model.title,
                          maxLength: 12,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            focusedBorder: fb,
                            enabledBorder: eb,
                            filled: true,
                            fillColor: fc,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text('제목'),
                            hintText: 'ex) NFC를 활용한 테이블 오더',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (v) => model.title = v,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          initialValue: model.content,
                          maxLines: 17,
                          decoration: InputDecoration(
                            label: Text(
                              '아이디어 설명',
                            ),
                            hintText:
                                '자유롭게 적어주시면 됩니다.\n\nex) 휴대폰에 간편결제를 등록해서 식당에 있는 각 테이블에 있는 NFC 스티커를 태그하면 서비스를 제공합니다.\n 해당 서비스는 고객이 테이블에서 휴대폰으로 메뉴를 고르고 결제까지 할 수 있는 서비스 입니다.\n 푸드코트나 카페에서는 조리가 끝나면 고객의 휴대폰으로 알림을 보낼 수 있습니다. 점주는 매출과 주문을 확인할 수 있습니다.\n 종업원의 주문 실수를 줄이고 및 빠른 회전율과 효율적인 동선으로 매출 증대를 기대할 수 있습니다.',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            focusedBorder: fb,
                            enabledBorder: eb,
                            filled: true,
                            fillColor: fc,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (v) => model.content = v,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

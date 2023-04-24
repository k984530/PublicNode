import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/function/filter.dart';
import 'package:node/function/login.dart';
import 'package:node/main.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/menu.dart';
import 'package:node/ui/page/splash/splash_page.dart';

class accountSettingPage extends ConsumerWidget {
  static const String route = '/accountSetting';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(writeAccountViewModelProvider);
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
                if (Contentfilter.filterContent(model.name) ||
                    Contentfilter.filterContent(model.contact) ||
                    Contentfilter.filterContent(model.content) ||
                    Contentfilter.filterContent(model.field)) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: const Text(
                        "비속어 표현이 포함되어 있습니다. 정정해주세요.",
                      ),
                    ),
                  );
                } else {
                  await model.write();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      menuPage.route, (route) => false);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: const Text(
                        "사용자 정보를 성공적으로 저장했습니다",
                      ),
                    ),
                  );
                }
              } catch (e) {
                print(e);
              }
            } else if (model.iOSenable) {
              if (AppleLoginName == '') AppleLoginName = 'Apple';
              model.name = AppleLoginName;

              await model.write();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(menuPage.route, (route) => false);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: const Text(
                    "사용자 정보를 성공적으로 저장했습니다",
                  ),
                ),
              );
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
              color: Colors.blueAccent.shade700,
            ),
            child: Text(
              '저장하기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '사용자 정보',
        ),
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
                      if (!AppleLoginbool || model.name != '')
                        Container(
                          height: 90,
                          padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                          child: TextFormField(
                            initialValue: model.name,
                            maxLength: 6,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              label: Text('이름'),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'ex) 홍길동',
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
                        height: 60,
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          initialValue: model.contact,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            label: Text('연락처'),
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'ex) 010-1234-5678',
                            focusedBorder: fb,
                            enabledBorder: eb,
                            filled: true,
                            fillColor: fc,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (v) => model.contact = v,
                        ),
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          initialValue: model.field,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            label: Text('분야'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: fb,
                            enabledBorder: eb,
                            filled: true,
                            fillColor: fc,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'ex) 개발, 디자인, 기획, 마케팅 등',
                          ),
                          onChanged: (v) => model.field = v,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        child: TextFormField(
                          initialValue: model.content,
                          maxLines: 12,
                          decoration: InputDecoration(
                            label: Text('자기 소개'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: fb,
                            enabledBorder: eb,
                            filled: true,
                            fillColor: fc,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText:
                                '''본인이 할 수 있는 일이나, 관심 있는 분야와 자유롭게 하고 싶은 말을 쓰면 됩니다.

ex) 안녕하세요 저는 flutter로 앱 개발을 주로하는 개발자입니다.
 MVVM 패턴 설계 및 iOS, Android 두 플랫폼에 동시에 배포할 수 있고 Firebase를 활용한 백엔드 구축 경험이 있습니다.
 사회적 약자들을 돕기 위한 서비스에 관심이 많으며, 내가 가진 능력보다 더 어려운 일에 적극적으로 도전하며 실력을 쌓아가길 희망합니다.
''',
                          ),
                          onChanged: (v) => model.content = v,
                        ),
                      ),
                      if (ref.read(accountRepositoryProvider).me != null)
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                      '계정을 삭제하시겠습니까? \n삭제시 구매된 제품은 복원할 수 없습니다.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          ref
                                              .read(accountRepositoryProvider)
                                              .delete(ref
                                                  .read(
                                                      accountRepositoryProvider)
                                                  .me!
                                                  .id as String);
                                          FirebaseAuth.instance.signOut();
                                          GoogleSignIn().signOut();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  splashPage.route,
                                                  (route) => false);
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
                          child: Container(
                            margin: EdgeInsets.all(15),
                            height: 50,
                            width: 130,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: Text(
                              '계정 삭제',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                              ),
                            ),
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

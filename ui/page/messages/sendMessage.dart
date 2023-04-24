import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';

class sendMessagePage extends ConsumerWidget {
  const sendMessagePage({super.key});
  static const String route = '/sendMessage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(writeMessageViewModelProvider);
    final account = ref.read(writeAccountViewModelProvider);
    final user = model.initial.account;
    final c = Colors.yellow.shade50;
    final borderc = Colors.lime.shade600;
    final s = [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 2.0,
        spreadRadius: 2.0,
        offset: Offset(2, 5),
      ),
    ];
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: GestureDetector(
          onTap: () {
            model.write(account.id as String);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text(
                  "${model.initial.team} 팀장에게 메시지를 성공적으로 보냈습니다!",
                ),
              ),
            );
            Navigator.of(context).pop();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.lime.shade600,
            ),
            child: Text(
              '보내기',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('${model.initial.team}에 보낼 내용'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: c,
                border: Border.all(
                  color: borderc,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: s,
              ),
              child: Text('이름 : ${user!.name}'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: c,
                border: Border.all(
                  color: borderc,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: s,
              ),
              child: Text('분야 : ${user.field}'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: c,
                border: Border.all(
                  color: borderc,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: s,
              ),
              child: Text('연락처 : ${user.contact!}'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: c,
                border: Border.all(
                  color: borderc,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: s,
              ),
              child: Text('소개 : ${user.content}'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextFormField(
                maxLines: 10,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  label: Text(
                    '내용',
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: '추가로 보낼 내용을 적어주세요.',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: borderc,
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: c,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: borderc,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (v) => model.content = v,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';

class readMessagePage extends ConsumerWidget {
  const readMessagePage({super.key});
  static const String route = '/readMessage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(writeMessageViewModelProvider);
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
      appBar: AppBar(
        title: Text('${model.initial.account!.name}님이 보낸 내용'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(messageRepositoryProvider)
                  .delete(model.initial.id as String);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.delete,
            ),
          ),
        ],
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
              child: Text('이름 : ${model.initial.account!.name}'),
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
              child: Text('분야 : ${model.initial.account!.field}'),
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
              child: Text('연락처 : ${model.initial.account!.contact}'),
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
              child: Text('소개 : ${model.initial.account!.content}'),
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
              child: Text('내용 : ${model.initial.content}'),
            ),
          ],
        ),
      ),
    );
  }
}

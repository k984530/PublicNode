import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/ideas_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/idea.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';

class editNoticePage extends ConsumerWidget {
  static const String route = '/editNotice';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String content = ref.read(messageRepositoryProvider).note['content'];
    final edit = ref.read(messageRepositoryProvider);
    final fb = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    );
    final eb = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blue.shade200, width: 2.0),
    );
    final fc = Colors.white;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: GestureDetector(
          onTap: () async {
            try {
              await edit.editNotice(content);
              Navigator.of(context)
                ..pop()
                ..pop();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: const Text(
                    "공지 내용을 성공적으로 저장했습니다!",
                  ),
                ),
              );
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
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
        title: Text('공지'),
      ),
      body: Column(
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
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: TextFormField(
                        initialValue: content,
                        maxLines: 17,
                        decoration: InputDecoration(
                          label: Text(
                            '내용',
                          ),
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
                        onChanged: (v) => content = v,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

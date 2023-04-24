import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/core/database/teams_database.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';
import 'package:node/ui/page/messages/readApply.dart';
import 'package:node/ui/page/messages/readMessage.dart';
import 'package:node/ui/page/teams/expalinTeam.dart';
import 'package:node/ui/page/teams/provider/toggle.dart';
import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';

class adminMessagePage extends ConsumerWidget {
  const adminMessagePage({super.key});

  static const String route = '/adminMessage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(applysProvider);
    final model = ref.read(writeMessageViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메세지함',
        ),
        centerTitle: true,
      ),
      body: messages.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: ((context, index) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    model.initial = data[index];
                    Navigator.of(context).pushNamed(readApplyPage.route);
                    if (data[index].read == false) {
                      await ref
                          .read(messageRepositoryProvider)
                          .readApply(data[index].id as String);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.shade700,
                      borderRadius: BorderRadius.circular(10),
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
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          data[index].read as bool
                              ? Icons.check
                              : Icons.mail_outline,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            '${data[index].account!.name} 님이 NODE에 지원하셨습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
        error: (error, stackTrace) {},
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/core/database/teams_database.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/ideas/expalinIdea.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';
import 'package:node/ui/page/messages/provider/write_message_view_model_provider.dart';
import 'package:node/ui/page/messages/readApply.dart';
import 'package:node/ui/page/messages/readMessage.dart';
import 'package:node/ui/page/teams/expalinTeam.dart';
import 'package:node/ui/page/teams/provider/toggle.dart';
import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';

class adminReportPage extends ConsumerWidget {
  const adminReportPage({super.key});

  static const String route = '/adminReport';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final ideaModel = ref.watch(writeIdeaViewModelProvider);
    final teamModel = ref.watch(writeTeamViewModelProvider);
    final accountModel = ref.watch(writeAccountViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '신고함',
        ),
        centerTitle: true,
      ),
      body: reports.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: ((context, index) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    if (data[index].type == 'idea') {
                      try {
                        await ideaModel.init(data[index].contentID as String);
                        Navigator.of(context).pushNamed(explainIdea.route);
                        if (data[index].read == false) {
                          await ref
                              .read(messageRepositoryProvider)
                              .readReport(data[index].contentID as String);
                        }
                      } catch (e) {
                        ref
                            .read(messageRepositoryProvider)
                            .reportDelete(data[index].contentID as String);
                      }
                    } else if (data[index].type == 'team') {
                      await teamModel.init(data[index].contentID as String);
                      accountModel.setAccount(teamModel.initial.userID);
                      Navigator.of(context).pushNamed(explainTeam.route);
                      if (data[index].read == false) {
                        await ref
                            .read(messageRepositoryProvider)
                            .readReport(data[index].contentID as String);
                      }
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
                            '${data[index].type} - ${data[index].title}에 신고가 들어왔습니다.',
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

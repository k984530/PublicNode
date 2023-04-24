import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/teams_database.dart';
import 'package:node/ui/page/accounts/provider/write_account_view_model_provider.dart';
import 'package:node/ui/page/teams/expalinTeam.dart';

import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';

class teamPage extends ConsumerWidget {
  const teamPage({super.key});
  static const String route = '/team';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamsProvider);
    final model = ref.watch(writeTeamViewModelProvider);
    final accountModel = ref.watch(writeAccountViewModelProvider);
    final account = ref.read(accountRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '팀 빌딩',
        ),
        centerTitle: true,
      ),
      body: teams.when(
        data: (data) {
          if (account.me!.ban != null) {
            data = data
                .where(
                  (team) => !account.me!.ban!.contains(
                    team.userID,
                  ),
                )
                .toList();
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: ((context, index) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    if (account.myClass != 'GUEST') {
                      await model.init(data[index].id);
                      accountModel.setAccount(data[index].userID);
                      Navigator.of(context).pushNamed(explainTeam.route);
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "GUEST 등급은 접근할 수 없습니다.\n회원권을 구매해주세요.",
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade400,
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
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data[index].name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    ' - ${data[index].ideaName} - ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  data[index].state ? '모집 중' : '모집 끝',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (data[index].state)
                                  Icon(
                                    Icons.accessibility_new_sharp,
                                    color: Colors.white,
                                  ),
                                if (!data[index].state)
                                  Icon(
                                    Icons.not_interested,
                                    color: Colors.white,
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

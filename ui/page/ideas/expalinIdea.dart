import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/ideas_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/rating.dart';
import 'package:node/models/report.dart';
import 'package:node/models/team.dart';
import 'package:node/ui/page/ideas/ideaSetting.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';
import 'package:node/ui/page/teams/teamSetting.dart';

class explainIdea extends ConsumerWidget {
  static const String route = '/explainIdea';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idea = ref.read(writeIdeaViewModelProvider);
    final teamModel = ref.watch(writeTeamViewModelProvider);
    final user = ref.read(accountRepositoryProvider).id;
    final myClass = ref.read(accountRepositoryProvider).myClass;
    bool isMe = idea.initial.userID == user;
    final rating = ref.watch(ratingProvider);
    final ratings = ref.watch(ratingsProvider(idea.id));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(idea.title),
        actions: [
          if (isMe || myClass == 'ADMIN')
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(createIdea.route);
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
                                  .banAccount(idea.initial.userID as String);
                            } catch (e) {
                              print(e);
                            }
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pushReplacementNamed(ideaPage.route);
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
                                        title: idea.title,
                                        contentID: idea.id,
                                        type: 'idea',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2.0,
                    spreadRadius: 4.0,
                    offset: Offset(2, 7),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Text(
                  idea.content,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
              width: MediaQuery.of(context).size.width,
              height: 230,
              decoration: BoxDecoration(
                color: Colors.cyan.shade100.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    offset: Offset(2, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ratings.when(
                    data: (List<Rating> data) {
                      return Row(
                        children: [
                          Spacer(),
                          Text(
                            '평 가    (${data.length}) ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          Spacer(),
                        ],
                      );
                    },
                    error: (e, s) => Center(
                        child: Expanded(
                      flex: 2,
                      child: Text(e.toString()),
                    )),
                    loading: () {
                      return Expanded(
                        flex: 2,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      ratings.when(
                        data: (data) {
                          double creative = 0;
                          double profit = 0;
                          double feasible = 0;
                          for (int i = 0; i < data.length; i++) {
                            creative += data[i].creative;
                            profit += data[i].profit;
                            feasible += data[i].feasible;
                          }
                          creative /= data.length;
                          profit /= data.length;
                          feasible /= data.length;
                          return Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: SizedBox(
                                    height: 40,
                                    child: Text(
                                      '독창성    ${creative.toStringAsFixed(2)}',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Text(
                                    '수익성    ${profit.toStringAsFixed(2)}',
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Text(
                                    '필요성    ${feasible.toStringAsFixed(2)}',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        error: (e, s) => Center(
                            child: Expanded(
                          flex: 2,
                          child: Text(e.toString()),
                        )),
                        loading: () {
                          return Expanded(
                            flex: 2,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      rating.decrease('c');
                                    },
                                    child: Icon(
                                      Icons.remove,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < rating.creative;
                                            i++)
                                          Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.yellow.shade200,
                                          ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rating.increase('c');
                                    },
                                    child: Icon(
                                      Icons.add,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      rating.decrease('p');
                                    },
                                    child: Icon(Icons.remove),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: rating.profit,
                                      itemBuilder: (context, index) {
                                        return Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.yellow.shade200,
                                        );
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rating.increase('p');
                                    },
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      rating.decrease('f');
                                    },
                                    child: Icon(
                                      Icons.remove,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: rating.feasible,
                                      itemBuilder: (context, index) {
                                        return Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.yellow.shade200,
                                        );
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rating.increase('f');
                                    },
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Consumer(
                    builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              teamModel.initial = teamModel.initial.copyWith(
                                ideaID: idea.id,
                                ideaName: idea.title,
                                ideaContent: idea.content,
                              );
                              Navigator.of(context)
                                  .pushNamed(teamSettingPage.route);
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue.shade300,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                '팀 만들기',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ref
                                  .read(ideaRepositoryProvider)
                                  .addNewRating(
                                    Rating(
                                      creative: rating.creative,
                                      profit: rating.profit,
                                      feasible: rating.feasible,
                                    ),
                                    idea.id,
                                  );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: const Text(
                                    "성공적으로 평가를 등록했습니다.",
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue.shade300,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Text('평가하기'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            ), //콘테이너
          ],
        ),
      ),
    );
  }
}

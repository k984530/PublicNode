import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/ideas_database.dart';
import 'package:node/models/idea.dart';
import 'package:node/models/rating.dart';
import 'package:node/ui/page/ideas/ideaSetting.dart';
import 'package:node/ui/page/ideas/expalinIdea.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';
import 'package:riverpod/riverpod.dart';

class ideaPage extends ConsumerWidget {
  const ideaPage({super.key});
  static const String route = '/idea';

  getAverage(List<QueryDocumentSnapshot<Object?>> l) {
    final len = l.length;
    double total = 0;
    for (int i = 0; i < len; i++) {
      total += l[i].get('creative') as int;
      total += l[i].get('profit') as int;
      total += l[i].get('feasible') as int;
    }
    return total / len;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ideas = ref.watch(ideasProvider);
    final model = ref.watch(writeIdeaViewModelProvider);
    final idea = ref.watch(ideaRepositoryProvider);
    final account = ref.watch(accountRepositoryProvider);
    final colors = [
      Colors.red.shade400,
      Colors.orange,
      Colors.yellow,
      Colors.cyan,
      Colors.blue,
      Colors.green
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (account.myClass != 'GUEST') {
            ref.read(writeIdeaViewModelProvider).clear();
            Navigator.pushNamed(context, createIdea.route);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: const Text(
                  "GUEST 등급은 접근할 수 없습니다.",
                ),
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          '아이디어',
        ),
        centerTitle: true,
      ),
      body: ideas.when(
        data: (data) {
          if (account.me!.ban != null) {
            data = data
                .where((idea) => !account.me!.ban!.contains(idea.userID))
                .toList();
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: ((context, index) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    if (account.myClass != 'GUEST') {
                      await model.init(data[index].id as String);
                      idea.saveID(data[index].id as String);
                      Navigator.of(context).pushNamed(explainIdea.route);
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: const Text(
                            "GUEST 등급은 접근할 수 없습니다.",
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
                        color: colors[index % colors.length].withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.23),
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                            offset: Offset(2, 5),
                          ),
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.lightbulb_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            data[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    final ratings = ref.watch(
                                      ratingsProvider(data[index].id as String),
                                    );
                                    return ratings.when(
                                      data: (data) {
                                        String rating = '-';
                                        if (data.isNotEmpty) {
                                          double result = 0;
                                          for (Rating r in data) {
                                            result += r.profit +
                                                r.creative +
                                                r.feasible;
                                          }
                                          result /= data.length;
                                          rating = result
                                              .toStringAsFixed(2)
                                              .toString();
                                        }
                                        return Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '평점   $rating',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                      loading: () {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        return Center(
                                          child: Text(error.toString()),
                                        );
                                      },
                                    );
                                  }),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.fromLTRB(0, 0, 15, 5),
                                    child: Text(
                                      '${data[index].author}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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

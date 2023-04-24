import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/models/team.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';

import '../../models/account.dart';

final teamRepositoryProvider = Provider.autoDispose((ref) => TeamRepository());

final teamsProvider = StreamProvider.autoDispose((ref) {
  final teamRep = ref.read(teamRepositoryProvider);
  return teamRep.teamsStream;
});

class TeamRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;
  init() {
    _user = FirebaseAuth.instance.currentUser;
    id = _user!.uid;
    notifyListeners();
  }

  Future<void> writeTeam(Team team) async {
    bool hasData = team.id.isNotEmpty;
    final ref = _firestore.collection('teams').doc(team.ideaID + team.userID);
    if (hasData) {
      await ref.update(
        team
            .copyWith(
                name: team.name,
                userID: team.userID,
                time: DateTime.now(),
                ideaName: team.ideaName,
                ideaContent: team.ideaContent,
                fields: team.fields,
                state: team.state,
                id: team.ideaID + team.userID)
            .toMap(),
      );
    } else {
      await ref.set(
        team
            .copyWith(
                name: team.name,
                userID: team.userID,
                time: DateTime.now(),
                ideaName: team.ideaName,
                ideaContent: team.ideaContent,
                ideaID: team.ideaID,
                fields: team.fields,
                state: team.state,
                id: team.ideaID + team.userID)
            .toMap(),
        SetOptions(merge: true),
      );
    }
    notifyListeners();
  }

  Future<Team> returnTeam(String teamDocID) async {
    return await _firestore.collection('teams').doc(teamDocID).get().then(
          (value) => Team.fromFirestore(value),
        );
  }

  String id = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Team>> get teamsStream => _firestore
      .collection('teams')
      .orderBy('time', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Team.fromFirestore(e),
            )
            .toList(),
      );
  void delete(String id) {
    _firestore.collection('teams').doc(id).delete();
  }
}

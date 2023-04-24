import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/models/idea.dart';
import 'package:node/models/rating.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';

final ideaRepositoryProvider =
    Provider.autoDispose((ref) => IdeaRepository(ref));

final ratingsProvider = StreamProvider.family.autoDispose((ref, String id) {
  final ideaRep = ref.read(ideaRepositoryProvider);
  return ideaRep.ratingsStream(id);
});

final ideasProvider = StreamProvider.autoDispose((ref) {
  final ideaRep = ref.read(ideaRepositoryProvider);
  return ideaRep.ideasStream;
});

class IdeaRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  IdeaRepository(this._ref);

  Future<void> writeIdea(Idea idea) async {
    bool hasData = idea.id!.isNotEmpty;
    final ref = _firestore.collection('ideas').doc(hasData ? idea.id : null);
    final account = _ref.read(accountRepositoryProvider).me!;
    if (hasData) {
      await ref.update(
        idea
            .copyWith(
                author: account.name,
                time: DateTime.now(),
                userID: account.id,
                id: ref.id)
            .toMap(),
      );
    } else {
      await ref.set(
        idea
            .copyWith(
                author: account.name,
                time: DateTime.now(),
                userID: account.id,
                id: ref.id)
            .toMap(),
        SetOptions(merge: true),
      );
    }
  }

  Stream<List<Idea>> get ideasStream => _firestore
      .collection('ideas')
      .orderBy('time', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Idea.fromFirestore(e),
            )
            .toList(),
      );

  int len = 0;
  Stream<List<Rating>> ratingsStream(String ideaID) {
    return _firestore
        .collection('ideas')
        .doc(ideaID)
        .collection('ratings')
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Rating.fromFirestore(e),
              )
              .toList(),
        );
  }

  void delete(String id) {
    _firestore.collection('ideas').doc(id).delete();
  }

  Future<Idea> returnIdea(String ideaDocID) async {
    return await _firestore.collection('ideas').doc(ideaDocID).get().then(
          (value) => Idea.fromFirestore(value),
        );
  }

  Idea idea = Idea.empty();
  String docID = '';
  void saveID(String ideaDocID) {
    docID = ideaDocID;
    notifyListeners();
  }

  Future<List<DocumentSnapshot>> ideasPaginateFuture(
      {required int limit, DocumentSnapshot? lastDocument}) async {
    var docRef =
        _firestore.collection('ideas').orderBy('time', descending: true);
    if (lastDocument != null) {
      docRef = docRef.startAfterDocument(lastDocument);
    }

    return docRef.limit(limit).get().then((value) => value.docs);
  }

  Future<bool> addNewRating(Rating r, String docID) async {
    final userID = _ref.read(accountRepositoryProvider).id;
    final _ideaDoc = _firestore
        .collection('ideas')
        .doc(docID)
        .collection('ratings')
        .doc(userID);

    try {
      await _ideaDoc.set(
        {
          'creative': r.creative,
          'profit': r.profit,
          'feasible': r.feasible,
          'userID': userID,
          'time': DateTime.now(),
        },
      );
      notifyListeners();
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
}

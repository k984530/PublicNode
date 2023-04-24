import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/models/idea.dart';
import 'package:node/models/message.dart';
import 'package:node/models/rating.dart';
import 'package:node/models/report.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';

final messageRepositoryProvider =
    Provider.autoDispose((ref) => MessageRepository(ref));

final messagesProvider = StreamProvider.autoDispose((ref) {
  final messageRep = ref.read(messageRepositoryProvider);
  return messageRep.messagesStream;
});

final applysProvider = StreamProvider.autoDispose((ref) {
  final messageRep = ref.read(messageRepositoryProvider);
  return messageRep.applysStream;
});

final reportsProvider = StreamProvider.autoDispose((ref) {
  final messageRep = ref.read(messageRepositoryProvider);
  return messageRep.reportsStream;
});

class MessageRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  MessageRepository(this._ref);

  Future<void> sendMessage(Message message, String toID) async {
    bool hasData = message.id!.isNotEmpty;
    final ref = _firestore
        .collection('messages')
        .doc(toID)
        .collection('mailbox')
        .doc(message.account!.id);
    if (hasData) {
      await ref.update(
        message
            .copyWith(
                id: ref.id,
                account: message.account,
                time: DateTime.now(),
                content: message.content,
                read: message.read)
            .toMap(),
      );
    } else {
      await ref.set(
        message
            .copyWith(
              id: ref.id,
              team: message.team,
              account: message.account,
              time: DateTime.now(),
              content: message.content,
              read: message.read,
            )
            .toMap(),
        SetOptions(merge: true),
      );
    }
  }

  Future<void> editNotice(String content) async {
    await _firestore.collection('messages').doc('Admin').update({
      'content': content,
    });
    notifyListeners();
  }

  Future<void> sendApply(Message message) async {
    bool hasData = message.id!.isNotEmpty;
    final ref = _firestore
        .collection('messages')
        .doc('Admin')
        .collection('applybox')
        .doc(message.account!.id);
    if (hasData) {
      await ref.update(
        message
            .copyWith(
                id: ref.id,
                account: message.account,
                time: DateTime.now(),
                content: message.content,
                read: message.read)
            .toMap(),
      );
    } else {
      await ref.set(
        message
            .copyWith(
              id: ref.id,
              team: message.team,
              account: message.account,
              time: DateTime.now(),
              content: message.content,
              read: message.read,
            )
            .toMap(),
        SetOptions(merge: true),
      );
    }
  }

  Future<void> sendReport(Report report) async {
    final ref = _firestore
        .collection('messages')
        .doc('Admin')
        .collection('reportbox')
        .doc(report.contentID);
    await ref.set(
      report
          .copyWith(
            contentID: report.contentID,
            time: DateTime.now(),
            type: report.type,
            read: false,
          )
          .toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> readMessage(String messageID) async {
    final myID = _ref.read(accountRepositoryProvider).id;
    await _firestore
        .collection('messages')
        .doc(myID)
        .collection('mailbox')
        .doc(messageID)
        .update({'read': true});
  }

  Future<void> readApply(String applyID) async {
    await _firestore
        .collection('messages')
        .doc('Admin')
        .collection('applybox')
        .doc(applyID)
        .update({'read': true});
  }

  Future<void> readReport(String reportID) async {
    await _firestore
        .collection('messages')
        .doc('Admin')
        .collection('reportbox')
        .doc(reportID)
        .update({'read': true});
  }

  Stream<List<Message>> get messagesStream => _firestore
      .collection('messages')
      .doc(_ref.read(accountRepositoryProvider).id)
      .collection('mailbox')
      .orderBy('time', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Message.fromFirestore(e),
            )
            .toList(),
      );

  Map<String, dynamic> note = {'title': '', 'content': ''};

  Future<Map<String, dynamic>?> notify() async {
    return await _firestore
        .collection('messages')
        .doc('Admin')
        .get()
        .then((value) {
      note = value.data() as Map<String, dynamic>;
      return note;
    });
  }

  Stream<List<Message>> get applysStream => _firestore
      .collection('messages')
      .doc('Admin')
      .collection('applybox')
      .orderBy('time', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Message.fromFirestore(e),
            )
            .toList(),
      );

  Stream<List<Report>> get reportsStream => _firestore
      .collection('messages')
      .doc('Admin')
      .collection('reportbox')
      .orderBy('time', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Report.fromFirestore(e),
            )
            .toList(),
      );

  void delete(String id) {
    _firestore
        .collection('messages')
        .doc(_ref.read(accountRepositoryProvider).id)
        .collection('mailbox')
        .doc(id)
        .delete();
  }

  void applyDelete(String id) {
    _firestore
        .collection('messages')
        .doc('Admin')
        .collection('applybox')
        .doc(id)
        .delete();
  }

  void reportDelete(String id) {
    _firestore
        .collection('messages')
        .doc('Admin')
        .collection('reportbox')
        .doc(id)
        .delete();
  }

  Future<List<DocumentSnapshot>> messagesPaginateFuture(
      {required int limit, DocumentSnapshot? lastDocument}) async {
    var docRef =
        _firestore.collection('ideas').orderBy('time', descending: true);
    if (lastDocument != null) {
      docRef = docRef.startAfterDocument(lastDocument);
    }

    return docRef.limit(limit).get().then((value) => value.docs);
  }
}

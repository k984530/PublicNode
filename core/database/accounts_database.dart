import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/idea.dart';
import 'package:node/models/rating.dart';
import 'package:node/ui/page/ideas/mainIdeaPage.dart';
import 'package:node/ui/page/accounts/accountSetting.dart';
import 'package:node/ui/page/informations/eula.dart';

import '../../models/account.dart';

final accountInitiate =
    FutureProvider.autoDispose.family(((ref, BuildContext context) async {
  await ref.read(accountRepositoryProvider).initAccount(context);
  await ref.read(messageRepositoryProvider).notify();
  return ref.read(accountRepositoryProvider).myClass;
}));

final accountRepositoryProvider =
    Provider.autoDispose((ref) => AccountRepository());
final accountProvider = Provider.autoDispose(
  (ref) => Account(
    id: FirebaseAuth.instance.currentUser!.uid,
    name: '',
    contact: '',
    field: '',
    content: '',
    classes: 'GOLD',
    ban: [],
  ),
);
final accountSetProvider = FutureProvider.autoDispose(((ref) async {
  return await ref.read(accountRepositoryProvider).setMyAccount();
}));

class AccountRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;
  init() {
    _user = FirebaseAuth.instance.currentUser;
    id = _user!.uid;
    notifyListeners();
  }

  Future<void> writeAccount(Account account) async {
    final ref = _firestore.collection('users').doc(_user!.uid);
    await ref.set(
      account.copyWith(id: _user!.uid).toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> punishAccount(Account account) async {
    final ref = _firestore.collection('users').doc(account.id);
    await ref.set(
      account.copyWith(id: account.id, classes: 'GUEST').toMap(),
      SetOptions(merge: true),
    );
  }

  // Future<void> buyMembership(Account account) async {
  //   final ref = _firestore.collection('users').doc(_user!.uid);
  //   await ref.update(
  //     account.copyWith(id: _user!.uid, classes: 'GOLD').toMap(),
  //   );
  //   notifyListeners();
  // }

  String id = FirebaseAuth.instance.currentUser!.uid;
  String myClass = '';
  Account? me = null;

  initAccount(BuildContext context) async {
    try {
      final exist = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .get()
          .then((value) => value['contact'] != '');

      if (!exist) {
        await setMyAccount();
        Navigator.of(context).pushReplacementNamed(eulaPage.route);
      } else {
        await setMyAccount();
      }
    } catch (e) {
      Navigator.of(context).pushReplacementNamed(eulaPage.route);
    }
  }

  Future<void> banAccount(String AccountID) async {
    await _firestore.collection('users').doc(me!.id as String).set(
      {
        'ban': FieldValue.arrayUnion([AccountID]),
      },
      SetOptions(merge: true),
    );
    await setMyAccount();
    notifyListeners();
  }

  Future<void> releaseAccount() async {
    await _firestore.collection('users').doc(me!.id as String).set(
      {
        'ban': [''],
      },
      SetOptions(merge: true),
    );
    await setMyAccount();
    notifyListeners();
  }

  Future<bool> setMyAccount() async {
    me = await _firestore
        .collection('users')
        .doc(_user!.uid.isEmpty ? null : _user!.uid)
        .get()
        .then(
          (value) => Account.fromFirestore(value),
        );
    myClass = me!.classes as String;
    notifyListeners();
    return myClass != '';
  }

  Future<Account> returnThisAccount(String uid) async {
    return _firestore.collection('users').doc(uid).get().then(
          (value) => Account.fromFirestore(value),
        );
  }

  Future<void> hasAccount(BuildContext context) async {
    final bool hasData = await _firestore
        .collection('users')
        .doc(_user!.uid.isEmpty ? null : _user!.uid)
        .get()
        .then(
          (value) => value.exists,
        );
    if (!hasData) {
      Navigator.of(context).pushNamed(accountSettingPage.route);
    } else {
      myClass = await _firestore.collection('users').doc(id).get().then(
            (value) => Account.fromFirestore(value).classes as String,
          );
    }
    notifyListeners();
  }

  Stream<List<Account>> get accountsStream => _firestore
      .collection('users')
      .orderBy('time', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Account.fromFirestore(e),
            )
            .toList(),
      );
  void delete(String id) {
    _firestore.collection('users').doc(id).delete();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/function/login.dart';
import 'package:node/main.dart';
import 'package:node/models/account.dart';
import 'package:node/ui/providers/loading_provider.dart';

final writeAccountViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => WriteAccountViewModel(ref));

class WriteAccountViewModel extends ChangeNotifier {
  final Ref _ref;

  WriteAccountViewModel(this._ref);

  Account? _initial;
  Account get initial => _initial ?? Account.empty();
  set initial(Account initial) {
    _initial = initial;
  }

  bool get edit => initial.id!.isNotEmpty;
  String _name = '';
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String _content = '';
  String get content => _content;
  set content(String content) {
    _content = content;
    notifyListeners();
  }

  String _field = '';
  String get field => _field;
  set field(String field) {
    _field = field;
    notifyListeners();
  }

  String _contact = '';
  String get contact => _contact;
  set contact(String contact) {
    _contact = contact;
    notifyListeners();
  }

  bool get enable =>
      name.isNotEmpty &&
      content.isNotEmpty &&
      field.isNotEmpty &&
      contact.isNotEmpty;

  bool get iOSenable =>
      AppleLoginbool &&
      content.isNotEmpty &&
      field.isNotEmpty &&
      contact.isNotEmpty;

  Loading get _loading => _ref.read(loadingProvider);
  AccountRepository get _repository => _ref.read(accountRepositoryProvider);

  void init() {
    final account = _ref.read(accountRepositoryProvider);
    name = account.me!.name ?? '';
    contact = account.me!.contact ?? '';
    content = account.me!.content ?? '';
    field = account.me!.field ?? '';
    initial = account.me!;
  }

  Account? account;
  String? id;

  Future<void> setAccount(String uid) async {
    account = await _ref.read(accountRepositoryProvider).returnThisAccount(uid);
    id = uid;
    name = account!.name ?? '';
    contact = account!.contact ?? '';
    content = account!.content ?? '';
    field = account!.field ?? '';
  }

  Future<void> write() async {
    initial =
        initial.copyWith(classes: _ref.read(accountRepositoryProvider).myClass);
    if (initial.classes != 'ADMIN' &&
        initial.classes != 'YONSEI' &&
        initial.classes != 'GUEST' &&
        initial.classes != 'GOLD') {
      if (FirebaseAuth.instance.currentUser!.email!.contains('@yonsei.ac.kr')) {
        initial = initial.copyWith(classes: 'YONSEI');
      } else {
        initial = initial.copyWith(classes: 'GOLD'); // 원래는 GUSET
      }
    }

    final updated = initial.copyWith(
      id: initial.id,
      name: name,
      contact: contact,
      content: content,
      field: field,
      classes: initial.classes,
      ban: initial.ban,
    );
    _loading.start();
    try {
      await _repository.writeAccount(updated);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error(e);
    }
  }

  void clear() {
    _initial = null;
    _name = '';
    _content = '';
    _field = '';
    _contact = '';
  }
}

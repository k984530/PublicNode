import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/ideas_database.dart';
import 'package:node/core/database/messages_database.dart';
import 'package:node/models/account.dart';
import 'package:node/models/idea.dart';
import 'package:node/models/message.dart';
import 'package:node/ui/providers/loading_provider.dart';

final writeMessageViewModelProvider =
    ChangeNotifierProvider((ref) => WriteMessageViewModel(ref));

class WriteMessageViewModel extends ChangeNotifier {
  final Ref _ref;

  WriteMessageViewModel(this._ref);

  Message? _initial;
  Message get initial => _initial!;
  set initial(Message initial) {
    _initial = initial;
  }

  String _content = '';
  String get content => _content;
  set content(String title) {
    _content = title;
    notifyListeners();
  }

  String _id = '';
  String get id => _id;
  set id(String id) {
    _id = id;
    notifyListeners();
  }

  bool get enable => content.isNotEmpty;

  Loading get _loading => _ref.read(loadingProvider);
  MessageRepository get _repository => _ref.read(messageRepositoryProvider);

  Future<void> write(String toID) async {
    final updated = initial.copyWith(
        id: id,
        account: initial.account,
        time: DateTime.now(),
        content: content,
        read: false);
    _loading.start();
    try {
      await _repository.sendMessage(updated, toID);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error(e);
    }
  }

  Future<void> apply() async {
    final updated = initial.copyWith(
        id: id,
        account: initial.account,
        time: DateTime.now(),
        content: content,
        read: false);
    _loading.start();
    try {
      await _repository.sendApply(updated);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error(e);
    }
  }

  void init(Account account, String teamName) {
    initial = Message().setMessage(account, teamName);
  }
}

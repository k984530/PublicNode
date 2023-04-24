import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/accounts_database.dart';
import 'package:node/core/database/teams_database.dart';
import 'package:node/models/team.dart';
import 'package:node/ui/page/ideas/provider/write_idea_view_model_provider.dart';
import 'package:node/ui/providers/loading_provider.dart';

final writeTeamViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => WriteTeamViewModel(ref));

class WriteTeamViewModel extends ChangeNotifier {
  final Ref _ref;
  WriteTeamViewModel(this._ref);

  Team? _initial;
  Team get initial => _initial ?? Team.empty();
  set initial(Team initial) {
    _initial = initial;
  }

  bool get edit => initial.id.isNotEmpty;

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

  Map<String, bool> _fields = {
    'plan': false,
    'develop': true,
    'design': true,
    'marketting': true,
    'etc': false
  };

  List<bool> fieldList() {
    return [
      fields['plan'] as bool,
      fields['develop'] as bool,
      fields['design'] as bool,
      fields['marketting'] as bool,
      fields['etc'] as bool,
    ];
  }

  Map<String, bool> get fields => _fields;
  set fields(Map<String, bool> fields) {
    _fields = fields;
  }

  void setfields(List<bool> boolList) {
    _fields = {
      'plan': boolList[0],
      'develop': boolList[1],
      'design': boolList[2],
      'marketting': boolList[3],
      'etc': boolList[4],
    };
    notifyListeners();
  }

  bool _state = true;
  bool get state => _state;
  set state(bool state) {
    _state = state;
  }

  void changeState() {
    _state = !_state;
    notifyListeners();
  }

  bool get enable => name.isNotEmpty && content.isNotEmpty;

  Loading get _loading => _ref.read(loadingProvider);
  TeamRepository get _repository => _ref.read(teamRepositoryProvider);

  Future<void> init(String teamDocID) async {
    final t = await _ref.read(teamRepositoryProvider).returnTeam(teamDocID);
    name = t.name;
    content = t.content;
    state = t.state;
    fields = {
      'plan': t.fields['plan'],
      'develop': t.fields['develop'],
      'design': t.fields['design'],
      'marketting': t.fields['marketting'],
      'etc': t.fields['etc'],
    };
    initial = t;
  }

  Future<void> write() async {
    final idea = _ref.read(writeIdeaViewModelProvider);
    final user = _ref.read(accountRepositoryProvider).id;
    final Team updated;
    if (initial.ideaName == '') {
      updated = initial.copyWith(
        name: name,
        userID: user,
        state: state,
        ideaName: idea.title,
        ideaContent: idea.content,
        ideaID: idea.id,
        content: content,
        fields: fields,
      );
    } else {
      updated = initial.copyWith(
        name: name,
        state: state,
        content: content,
        fields: fields,
      );
    }
    _loading.start();
    try {
      await _repository.writeTeam(updated);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error(e);
    }
    notifyListeners();
  }

  void clear() {
    _initial = null;
    _state = true;
    _fields = {
      'plan': false,
      'develop': true,
      'design': true,
      'marketting': true,
      'etc': false
    };
    _name = '';
    _content = '';
  }
}

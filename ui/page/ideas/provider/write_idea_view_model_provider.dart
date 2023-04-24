import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/database/ideas_database.dart';
import 'package:node/models/idea.dart';
import 'package:node/ui/providers/loading_provider.dart';

final writeIdeaViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => WriteIdeaViewModel(ref));

class WriteIdeaViewModel extends ChangeNotifier {
  final Ref _ref;

  WriteIdeaViewModel(this._ref);

  Idea? _initial;
  Idea get initial =>
      _initial ??
      Idea.empty().copyWith(
        time: DateTime.now(),
      );
  set initial(Idea initial) {
    _initial = initial;
  }

  bool get edit => id.isNotEmpty;

  String _title = '';
  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
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

  bool get enable => title.isNotEmpty && content.isNotEmpty;

  Loading get _loading => _ref.read(loadingProvider);
  IdeaRepository get _repository => _ref.read(ideaRepositoryProvider);

  Future<void> write() async {
    final updated = initial.copyWith(
      id: id,
      title: title,
      content: content,
    );
    _loading.start();
    try {
      await _repository.writeIdea(updated);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error(e);
    }
  }

  Future<void> init(String ideaDocID) async {
    final idea = await _ref.read(ideaRepositoryProvider).returnIdea(ideaDocID);
    id = idea.id as String;
    title = idea.title;
    content = idea.content;
    initial = idea;
  }

  void clear() {
    _initial = null;
    _id = '';
    _title = '';
    _content = '';
  }
}

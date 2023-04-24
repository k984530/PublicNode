import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/ui/page/teams/provider/write_team_view_model_provider.dart';

final fieldToggleProvider =
    ChangeNotifierProvider.autoDispose((ref) => fieldToggle(ref));

class fieldToggle extends ChangeNotifier {
  final Ref _ref;

  fieldToggle(this._ref);

  List<Widget> fields = <Widget>[
    Text('기획'),
    Text('개발'),
    Text('디자인'),
    Text('마케팅'),
    Text('기타'),
  ];

  List<bool> selectedFields = <bool>[
    false,
    true,
    true,
    true,
    false,
  ];

  void changeState(int i) {
    selectedFields[i] = !selectedFields[i];
    notifyListeners();
  }
}

class recruitToggle extends ChangeNotifier {
  bool state = true;
  void changeState() {
    state = !state;
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:node/models/account.dart';
import 'package:node/models/idea.dart';

class Team {
  String id;
  String userID;
  String name;
  String ideaName;
  String ideaContent;
  String ideaID;
  Map<String, dynamic> fields;
  bool state;
  String content;
  DateTime time;

  Team({
    required this.id,
    required this.name,
    required this.userID,
    required this.ideaName,
    required this.ideaContent,
    required this.ideaID,
    required this.fields,
    required this.state,
    required this.content,
    required this.time,
  });

  Team copyWith({
    String? id,
    String? userID,
    String? name,
    String? ideaName,
    String? ideaContent,
    String? ideaID,
    Map<String, dynamic>? fields,
    bool? state,
    String? content,
    DateTime? time,
  }) {
    return Team(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      name: name ?? this.name,
      ideaName: ideaName ?? this.ideaName,
      ideaContent: ideaContent ?? this.ideaContent,
      ideaID: ideaID ?? this.ideaID,
      fields: fields ?? this.fields,
      state: state ?? this.state,
      content: content ?? this.content,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'name': name,
      'ideaName': ideaName,
      'ideaContent': ideaContent,
      'ideaID': ideaID,
      'fields': fields,
      'state': state,
      'content': content,
      'time': DateTime.now(),
    };
  }

  factory Team.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Team(
      id: map['id'] as String,
      userID: map['userID'] as String,
      name: map['name'] as String,
      ideaName: map['ideaName'] as String,
      ideaContent: map['ideaContent'] as String,
      ideaID: map['ideaID'] as String,
      fields: Map<String, dynamic>.from(doc.get('fields')),
      state: map['state'] as bool,
      content: map['content'] as String,
      time: (map['time'] as Timestamp).toDate(),
    );
  }
  factory Team.empty() {
    return Team(
      id: '',
      userID: '',
      name: '',
      ideaName: '',
      ideaContent: '',
      ideaID: '',
      fields: {},
      state: true,
      content: '',
      time: DateTime.now(),
    );
  }
}

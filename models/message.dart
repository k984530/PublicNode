import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:node/models/account.dart';

class Message {
  String? id;
  Account? account;
  DateTime? time;
  String? content;
  String? team;
  bool? read;

  Message({
    this.id,
    this.account,
    this.time,
    this.content,
    this.team,
    this.read,
  });

  Message copyWith({
    String? id,
    Account? account,
    DateTime? time,
    String? content,
    String? team,
    bool? read,
  }) {
    return Message(
      id: id ?? this.id,
      account: account ?? this.account,
      time: time ?? this.time,
      content: content ?? this.content,
      team: team ?? this.team,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'account': account?.toMap(),
      'time': DateTime.now(),
      'content': content,
      'read': read,
      'team': team,
    };
  }

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      account: map['account'] != null
          ? Account.fromMap(map['account'] as Map<String, dynamic>)
          : null,
      time: map['time'] != null ? (map['time'] as Timestamp).toDate() : null,
      content: map['content'] != null ? map['content'] as String : null,
      read: map['read'] != null ? map['read'] as bool : null,
      team: map['read'] != null ? map['team'] as String : null,
    );
  }

  Message setMessage(Account account, String teamName) {
    return Message(
      id: '',
      team: teamName,
      account: account,
      content: '',
      time: DateTime.now(),
      read: false,
    );
  }
}

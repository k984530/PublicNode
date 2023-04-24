import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:node/models/account.dart';

class Report {
  String? title;
  String? contentID;
  String? type;
  DateTime? time;
  bool? read;

  Report({
    required this.title,
    required this.contentID,
    required this.type,
    this.time,
    this.read,
  });

  Report copyWith({
    String? title,
    String? contentID,
    String? type,
    DateTime? time,
    bool? read,
  }) {
    return Report(
      title: title ?? this.title,
      contentID: contentID ?? this.contentID,
      type: type ?? this.type,
      time: time ?? this.time,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'contentID': contentID,
      'type': type,
      'time': DateTime.now(),
      'read': read,
    };
  }

  factory Report.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Report(
      title: map['title'] != null ? map['title'] as String : null,
      contentID: map['contentID'] != null ? map['contentID'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      time: map['time'] != null ? (map['time'] as Timestamp).toDate() : null,
      read: map['read'] != null ? map['read'] as bool : null,
    );
  }
}

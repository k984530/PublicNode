// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Account {
  String? id;
  String? name;
  String? contact;
  String? field;
  String? content;
  String? classes;
  List? ban;

  Account({
    required this.id,
    required this.name,
    required this.contact,
    required this.field,
    required this.content,
    required this.classes,
    required this.ban,
  });

  Account copyWith({
    String? id,
    String? name,
    String? contact,
    String? field,
    String? content,
    String? classes,
    List? ban,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      field: field ?? this.field,
      content: content ?? this.content,
      classes: classes ?? this.classes,
      ban: ban ?? this.ban,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'contact': contact,
      'field': field,
      'content': content,
      'classes': classes,
      'ban': ban,
    };
  }

  factory Account.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Account(
      id: map['id'] as String,
      name: map['name'] as String,
      contact: map['contact'] as String,
      field: map['field'] as String,
      content: map['content'] as String,
      classes: map['classes'] as String,
      ban: map['ban'],
    );
  }

  factory Account.fromMap(Map<String, dynamic> m) {
    return Account(
      id: m['id'],
      name: m['name'],
      contact: m['contact'],
      field: m['field'],
      content: m['content'],
      classes: m['classes'],
      ban: m['ban'],
    );
  }

  factory Account.empty() => Account(
      id: '',
      name: '',
      contact: '',
      field: '',
      content: '',
      classes: '',
      ban: []);
}

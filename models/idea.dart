import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Idea {
  String? id;
  String title;
  String content;
  DateTime? time;
  String? userID;
  String? author;

  Idea({
    required this.title,
    required this.content,
    this.time,
    this.userID,
    this.author,
    this.id,
  });

  Idea copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? time,
    String? userID,
    String? author,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      time: time ?? this.time,
      userID: userID ?? this.userID,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'time': DateTime.now(),
      'userID': userID,
      'author': author,
    };
  }

  factory Idea.fromMap(Map<String, dynamic> m) {
    return Idea(
      id: m['id'],
      title: m['title'],
      content: m['content'],
      time: m['time'],
      userID: m['userID'],
      author: m['author'],
    );
  }

  factory Idea.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Idea(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      time: map['time'] != null ? (map['time'] as Timestamp).toDate() : null,
      userID: map['userID'] as String,
      author: map['author'] as String,
    );
  }

  factory Idea.empty() => Idea(
        id: '',
        title: '',
        content: '',
        time: DateTime.now(),
        userID: '',
        author: '',
      );
}

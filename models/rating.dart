import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratingProvider = ChangeNotifierProvider.autoDispose<Rating>(
  (ref) => Rating(
    creative: 3,
    profit: 3,
    feasible: 3,
  ),
);

class Rating extends ChangeNotifier {
  int creative;
  int profit;
  int feasible;
  int len = 0;

  Rating({
    required this.creative,
    required this.profit,
    required this.feasible,
  });

  void setlen(int i) {
    len = i;
    notifyListeners();
  }

  void increase(String s) {
    switch (s) {
      case 'c':
        if (creative < 5) {
          creative++;
          notifyListeners();
        }
        break;
      case 'p':
        if (profit < 5) {
          profit++;
          notifyListeners();
        }
        break;
      case 'f':
        if (feasible < 5) {
          feasible++;
          notifyListeners();
        }
        break;
    }
  }

  void decrease(String s) {
    switch (s) {
      case 'c':
        if (creative > 1) {
          creative--;
          notifyListeners();
        }
        break;
      case 'p':
        if (profit > 1) {
          profit--;
          notifyListeners();
        }
        break;
      case 'f':
        if (feasible > 1) {
          feasible--;
          notifyListeners();
        }
        break;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'creative': creative,
      'profit': profit,
      'feasible': feasible,
    };
  }

  factory Rating.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Rating(
      creative: map['creative'] as int,
      profit: map['profit'] as int,
      feasible: map['feasible'] as int,
    );
  }

  Rating copyWith({
    int? creative,
    int? profit,
    int? feasible,
  }) {
    return Rating(
      creative: creative ?? this.creative,
      profit: profit ?? this.profit,
      feasible: feasible ?? this.feasible,
    );
  }
}

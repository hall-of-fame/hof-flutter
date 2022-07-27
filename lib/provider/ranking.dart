import 'package:flutter/material.dart';

enum NumberDisplay { stickersCount, ranking }

class RankingProvider with ChangeNotifier {
  final searchController = TextEditingController();
  NumberDisplay _numberDisplay = NumberDisplay.stickersCount;

  NumberDisplay get numberDisplay => _numberDisplay;
  void switchNumberDisplay(context) {
    if (_numberDisplay == NumberDisplay.stickersCount) {
      _numberDisplay = NumberDisplay.ranking;
    } else {
      _numberDisplay = NumberDisplay.stickersCount;
    }
    notifyListeners();
  }

  RankingProvider() {
    searchController.addListener(() => notifyListeners());
  }
}

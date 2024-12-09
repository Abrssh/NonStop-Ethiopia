import 'package:flutter/material.dart';

class FirstProvider with ChangeNotifier {
  int _firstProviderValue = 0;

  int get firstProvValAcc => _firstProviderValue;

  void increment() {
    _firstProviderValue++;
    notifyListeners();
  }

  void decrement() {
    _firstProviderValue--;
    notifyListeners();
  }
}

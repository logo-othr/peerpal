import 'package:flutter/material.dart';

class ActivityViewModel extends ChangeNotifier {
  bool isVisible = true;

  void toogleIconVisibilitiy() {
    this.isVisible = !this.isVisible;
    notifyListeners();
  }
}

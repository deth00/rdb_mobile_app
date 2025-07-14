import 'package:flutter/foundation.dart';

class AuthRedirectNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void update(bool newState) {
    if (_isLoggedIn != newState) {
      _isLoggedIn = newState;
      notifyListeners();
    }
  }
}

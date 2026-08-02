import 'package:flutter/foundation.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({this.displayDuration = const Duration(seconds: 2)});

  final Duration displayDuration;

  bool _isReady = false;

  bool get isReady => _isReady;

  Future<void> start() async {
    await Future.delayed(displayDuration);
    _isReady = true;
    notifyListeners();
  }
}

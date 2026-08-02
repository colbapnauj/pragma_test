import 'package:flutter/foundation.dart';

import '../core/constants/app_config.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({this.displayDuration = AppConfig.splashDisplayDuration});

  final Duration displayDuration;

  bool _isReady = false;

  bool get isReady => _isReady;

  Future<void> start() async {
    await Future.delayed(displayDuration);
    _isReady = true;
    notifyListeners();
  }
}

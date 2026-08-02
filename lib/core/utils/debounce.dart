import 'dart:async';

class Debounce {
  Debounce({required this.duration});

  final Duration duration;
  Timer? _timer;

  void call(Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    cancel();
  }
}

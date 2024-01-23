// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// A Stopwatch driven by elapsed.
class GgFakeStopwatch implements Stopwatch {
  /// Creates an instance with a delegate returning the elapsed time
  GgFakeStopwatch({Duration Function()? elapsed}) : _elapsedExternal = elapsed;

  @override
  int get frequency => 10 * 1000 * 1000;

  @override
  void start() {
    if (_isRunning) {
      return;
    }

    _startDuration = _elapsed;
    _isRunning = true;
  }

  @override
  void stop() {
    _isRunning = false;
    _stopDuration = _elapsed - _startDuration;
  }

  @override
  void reset() {
    _stopDuration = Duration.zero;
    _startDuration = _elapsed;
  }

  @override
  int get elapsedTicks => (elapsed.inMicroseconds * 10).toInt();

  /// Set the elapsed time
  void elapse(Duration progress) {
    if (_elapsedExternal != null) {
      throw ArgumentError(
        'Don\'t call elapse when "elapsed()" callback is set.',
      );
    }

    if (!_isRunning) {
      return;
    }

    _elapsedInternal += progress;
  }

  @override
  Duration get elapsed {
    if (!_isRunning) {
      return _stopDuration;
    }

    return _elapsed - _startDuration + _stopDuration;
  }

  @override
  int get elapsedMicroseconds => elapsed.inMicroseconds;

  @override
  int get elapsedMilliseconds => elapsed.inMilliseconds;

  @override
  bool get isRunning => _isRunning;

  // ######################
  // Private
  // ######################

  final Duration Function()? _elapsedExternal;
  var _elapsedInternal = Duration.zero;
  bool _isRunning = false;
  Duration _startDuration = Duration.zero;
  Duration _stopDuration = Duration.zero;

  Duration get _elapsed => _elapsedExternal?.call() ?? _elapsedInternal;
}

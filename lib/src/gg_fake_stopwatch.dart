// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';

/// A Stopwatch drify by FakeAsync.elapsed.
class GgFakeStopwatch implements Stopwatch {
  GgFakeStopwatch({required this.fakeAsync});

  @override
  int get frequency => 1000 * 1000 * 1000;

  @override
  void start() {
    if (_isRunning) {
      return;
    }

    _startDuration = fakeAsync.elapsed;
    _isRunning = true;
  }

  @override
  void stop() {
    _isRunning = false;
    _stopDuration = fakeAsync.elapsed - _startDuration;
  }

  @override
  void reset() {
    _stopDuration = Duration.zero;
    _startDuration = fakeAsync.elapsed;
  }

  @override
  int get elapsedTicks =>
      ((elapsed.inMicroseconds / 1000.0 / 1000.0) * frequency).toInt();

  @override
  Duration get elapsed {
    if (!_isRunning) {
      return _stopDuration;
    }

    return fakeAsync.elapsed - _startDuration + _stopDuration;
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

  final FakeAsync fakeAsync;
  bool _isRunning = false;
  Duration _startDuration = Duration.zero;
  Duration _stopDuration = Duration.zero;
}

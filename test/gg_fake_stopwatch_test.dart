// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';
import 'package:gg_fake_stopwatch/gg_fake_stopwatch.dart';
import 'package:test/test.dart';

void main() {
  group('GgFakeStopwatch', () {
    late GgFakeStopwatch stopwatch;
    late FakeAsync fake;

    // .........................................................................
    void init(FakeAsync fk) {
      fake = fk;
      stopwatch = GgFakeStopwatch(elapsed: () => fk.elapsed);
    }

    // .........................................................................
    void elapseOneSecond() {
      fake.elapse(const Duration(seconds: 1));
    }

    // .........................................................................
    void expectMillisecondsElapsed(int milliseconds) {
      expect(stopwatch.elapsed.inMilliseconds, milliseconds);
      expect(stopwatch.elapsedMilliseconds, milliseconds);
      expect(stopwatch.elapsedMicroseconds, milliseconds * 1000);
      expect(
        stopwatch.elapsedTicks,
        stopwatch.elapsedMicroseconds * 10,
      );
    }

    // .........................................................................
    test('should be in sync with FakeAsync.elapsed', () {
      fakeAsync((fake) {
        init(fake);

        /// Stopwatch is not started. Elapsed will be zero.
        expectMillisecondsElapsed(0);
        expect(stopwatch.isRunning, isFalse);

        /// Time goes by.
        elapseOneSecond();

        /// Elapsed is still zero because stopwatch is not started.
        expectMillisecondsElapsed(0);

        /// Start the stopwatch
        stopwatch.start();
        expect(stopwatch.isRunning, isTrue);

        /// Elapsed is still zero because no additional time has elapsed yet
        expectMillisecondsElapsed(0);

        /// Elapse some time.
        elapseOneSecond();

        /// Stopwatch should be at one second now
        expectMillisecondsElapsed(1000);

        /// Stop the stopwatch
        stopwatch.stop();

        /// Stopwatch should still be at one second
        expectMillisecondsElapsed(1000);

        /// Start the stopwatch again
        stopwatch.start();

        /// Elapse some time
        elapseOneSecond();

        /// Stopwatch should be one second further
        expectMillisecondsElapsed(2000);

        /// Reset stopwatch
        stopwatch.reset();

        /// Stopwatch should be at zero again
        expectMillisecondsElapsed(0);

        /// Elapse some time
        elapseOneSecond();

        /// Stop watch should be at one second again
        expectMillisecondsElapsed(1000);

        /// Calling elapse() should throw
        expect(
          () => stopwatch.elapse(Duration.zero),
          throwsA(
            predicate(
              (ArgumentError p0) {
                expect(
                  p0.message,
                  'Don\'t call elapse when "elapsed()" callback is set.',
                );
                return true;
              },
            ),
          ),
        );

        /// Expect stopwatch to have right frequency.
        expect(stopwatch.frequency, 10 * 1000 * 1000);
      });
    });

    // .......................................................................
    test(
        'should allow to use elapse() when no elapsed() constructor param '
        'is given', () {
      fakeAsync((fake) {
        stopwatch = GgFakeStopwatch();

        void elapseOneSecond() => stopwatch.elapse(const Duration(seconds: 1));

        void expectMillisecondsElapsed(int ms) =>
            expect(stopwatch.elapsedMilliseconds, ms);

        /// Stopwatch is not started. Elapsed will be zero.
        expectMillisecondsElapsed(0);
        expect(stopwatch.isRunning, isFalse);

        /// Time goes by.
        elapseOneSecond();

        /// Elapsed is still zero because stopwatch is not started.
        expectMillisecondsElapsed(0);

        /// Start the stopwatch
        stopwatch.start();
        expect(stopwatch.isRunning, isTrue);

        /// Elapsed is still zero because no additional time has elapsed yet
        expectMillisecondsElapsed(0);

        /// Elapse some time.
        elapseOneSecond();

        /// Stopwatch should be at one second now
        expect(stopwatch.elapsedMilliseconds, 1000);

        /// Stop the stopwatch
        stopwatch.stop();

        /// Stopwatch should still be at one second
        expectMillisecondsElapsed(1000);

        /// Start the stopwatch again
        stopwatch.start();

        /// Elapse some time
        elapseOneSecond();

        /// Stopwatch should be one second further
        expectMillisecondsElapsed(2000);

        /// Reset stopwatch
        stopwatch.reset();

        /// Stopwatch should be at zero again
        expectMillisecondsElapsed(0);

        /// Elapse some time
        elapseOneSecond();

        /// Stop watch should be at one second again
        expectMillisecondsElapsed(1000);
      });
    });
  });
}

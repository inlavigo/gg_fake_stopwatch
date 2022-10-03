import 'package:fake_async/fake_async.dart';
import 'package:gg_fake_stopwatch/gg_fake_stopwatch.dart';

void ggPrint(String prefix, dynamic message) {
  print('$prefix $message');
}

void main() {
  fakeAsync((fakeAsync) {
    final stopwatch = GgFakeStopwatch(fakeAsync: fakeAsync);

    print('Stopwatch is not started. Elapsed will be zero.');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Time goes by.');
    fakeAsync.elapse(const Duration(seconds: 1));

    print('Elapsed is still zero because stopwatch is not started.');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Start the stopwatch');
    stopwatch.start();
    ggPrint('  isRunning:', stopwatch.isRunning);

    print('Elapsed is still zero because no additional time has elapsed yet');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Elapse some time.');
    fakeAsync.elapse(const Duration(seconds: 1));

    print('Stopwatch should be at one second now');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Stop the stopwatch');
    stopwatch.stop();

    print('Stopwatch should still be at one second');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Start the stopwatch again');
    stopwatch.start();

    print('Elapse some time');
    fakeAsync.elapse(const Duration(seconds: 1));

    print('Stopwatch should be one second further');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Reset stopwatch');
    stopwatch.reset();

    print('Stopwatch should be at zero again');
    ggPrint('  Elapsed:', stopwatch.elapsed);

    print('Elapse some time');
    fakeAsync.elapse(const Duration(seconds: 1));

    print('Stop watch should be at one second again');
    ggPrint('  Elapsed:', stopwatch.elapsed);
  });
}

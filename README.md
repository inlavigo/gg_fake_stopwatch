# GgFakeStopWatch

The default stopwatch implementation does not work correctly when used in
a `FakeAsync` callback. With `GgFakeStopwatch` this is sovled.

## Usage

```dart
// Instantiate a fake `FakeAsync` callback.
fakeAsync((fakeAsync) {
  // Create a GgFakeStopwatch instance handing over the fakeAsync instance.
  final stopwatch = GgFakeStopwatch(fakeAsync: fakeAsync);

  // Start the stopwatch
  stopwatch.start();

  // Elapse some time
  fakeAsync.elapse(Duration(seconds: 1));

  // Stopwatch.elapsed is in sync with fakeAsync.elapsed:
  assert(fakeAsync.elapsed == stopwatch.elapsed);
});
```

## Features and bugs

Please file feature requests and bugs at [GitHub](https://github.com/inlavigo/gg_fake_stopwatch).

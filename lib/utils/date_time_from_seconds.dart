/// Constructs a DateTime object from seconds.
///
/// Uses [DateTime.fromMilliSecondsSinceEpoch] with [seconds] multiplied by a
/// factor of 1000.
DateTime dateTimeFromSeconds(int seconds) =>
    DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

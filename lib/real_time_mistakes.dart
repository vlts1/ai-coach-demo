enum RealTimeMistakes {
  handsDown,
  chinUp,
}

extension RealTimeMistakesExtension on RealTimeMistakes {
  String get solution {
    switch (this) {
      case RealTimeMistakes.handsDown:
        return 'Hands up';
      case RealTimeMistakes.chinUp:
        return 'Tuck your chin';
      default:
        return '';
    }
  }
}
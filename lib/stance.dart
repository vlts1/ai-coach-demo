enum Stance {
  /// For right handed people. Lead/front foot and arm are the left
  ortho,
  // For left handed people. Lead/front foot and arm are the right
  paw
}

extension StanceExtension on Stance {
  String get stringValue {
    switch (this) {
      case Stance.ortho:
        return 'Orthodox';
      case Stance.paw:
        return 'Southpaw';
      default:
        throw Exception('Unknown stance');
    }
  }
}
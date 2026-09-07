enum PgsStatus { notStarted, onGoing, completed }

extension PgsStatusExtension on PgsStatus {
  int toInt() {
    switch (this) {
      case PgsStatus.notStarted:
        return 0;
      case PgsStatus.onGoing:
        return 1;
      case PgsStatus.completed:
        return 2;
    }
  }

  static PgsStatus fromInt(int value) {
    switch (value) {
      case 1:
        return PgsStatus.onGoing;
      case 2:
        return PgsStatus.completed;
      default:
        return PgsStatus.notStarted;
    }
  }
}

import 'package:onboardingapp/core/utils/validation_utils.dart';
import 'package:onboardingapp/data/models/task_with_user_task.dart';

extension StringExtensions on String {
  String get toUserId => replaceAll('@', '_').replaceAll('.', '_');

  bool get isValidEmail {
    return ValidationUtils.isValidEmail(this);
  }

  bool get isValidName {
    return ValidationUtils.isValidName(this);
  }
}

extension DoubleExtensions on double {
  int get toPercentage => (this * 100).toInt();
}

extension ListExtensions<T> on List<T> {
  List<T> get sortedByDefault {
    if (T == TaskWithUserTask) {
      return cast<TaskWithUserTask>()
          .sortedBy((item) => item.task.isDefault ? 0 : 1)
          .cast<T>()
          .toList();
    }
    return this;
  }
}

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> sortedBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = toList();
    list.sort((a, b) => keySelector(a).compareTo(keySelector(b)));
    return list;
  }
}
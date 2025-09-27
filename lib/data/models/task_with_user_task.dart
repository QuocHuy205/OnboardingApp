import 'package:onboardingapp/data/models/task_model.dart';
import 'package:onboardingapp/data/models/user_task_model.dart';

class TaskWithUserTask {
  final TaskModel task;
  final UserTaskModel userTask;

  TaskWithUserTask({
    required this.task,
    required this.userTask,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskWithUserTask &&
        other.task == task &&
        other.userTask == userTask;
  }

  @override
  int get hashCode => task.hashCode ^ userTask.hashCode;
}
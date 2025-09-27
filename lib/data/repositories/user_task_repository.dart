import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:onboardingapp/data/models/user_task_model.dart';
import '../models/task_model.dart';
import '../models/task_with_user_task.dart';
import '../services/firebase_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/utils/validation_utils.dart';
import '../../core/utils/date_utils.dart';

class UserTaskRepository extends GetxService {
  final FirebaseService _firebaseService = Get.find();

  // Create user tasks for new employee
  Future<void> createUserTasks(String userId) async {
    try {
      final tasksSnapshot = await _firebaseService.getTasksRef()
          .orderByChild('default')
          .equalTo(true)
          .get();

      if (tasksSnapshot.exists) {
        final Map<String, dynamic> updates = {};
        final tasksData = tasksSnapshot.value as Map<dynamic, dynamic>;

        tasksData.forEach((taskId, taskData) {
          final task = TaskModel.fromMap(Map<String, dynamic>.from(taskData));
          final userTask = UserTaskModel(
            taskId: task.id,
            userId: userId,
            completed: false,
            completedDate: '',
          );
          updates['${FirebaseConstants.userTasksPath}/$userId/${task.id}'] = userTask.toMap();
        });

        await _firebaseService.database.update(updates);
      }
    } catch (e) {
      throw Exception('Lỗi tạo user tasks: ${e.toString()}');
    }
  }

  // Get user tasks with details stream
  Stream<List<TaskWithUserTask>> getUserTasksWithDetailsStream(String userId) {
    return _firebaseService.getAllTasksStream().asyncMap((allTasks) async {
      try {
        final userTasksSnapshot = await _firebaseService
            .getUserTasksRef()
            .child(userId)
            .get();

        final List<TaskWithUserTask> taskDetails = [];

        if (userTasksSnapshot.exists) {
          final userTasksData = userTasksSnapshot.value as Map<dynamic, dynamic>;

          userTasksData.forEach((taskId, userTaskData) {
            final userTask = UserTaskModel.fromMap(Map<String, dynamic>.from(userTaskData));
            final task = allTasks.firstWhereOrNull((t) => t.id == userTask.taskId);

            if (task != null) {
              taskDetails.add(TaskWithUserTask(task: task, userTask: userTask));
            }
          });
        }

        // Sort tasks: default tasks first, then by name
        taskDetails.sort((a, b) {
          if (a.task.isDefault && !b.task.isDefault) return -1;
          if (!a.task.isDefault && b.task.isDefault) return 1;
          return a.task.name.compareTo(b.task.name);
        });

        return taskDetails;
      } catch (e) {
        return <TaskWithUserTask>[];
      }
    });
  }

  // Update task status
  Future<void> updateTaskStatus(String userId, String taskId, bool isCompleted) async {
    try {
      final Map<String, dynamic> updates = {
        'completed': isCompleted,
        'completedDate': isCompleted ? AppDateUtils.getCurrentDate() : '',
      };

      await _firebaseService.getUserTaskRef(userId, taskId).update(updates);
    } catch (e) {
      throw Exception('Lỗi cập nhật task status: ${e.toString()}');
    }
  }

  // Create custom user task
  Future<void> createCustomUserTask(String userId, String taskName, String createdBy) async {
    try {
      if (!ValidationUtils.isValidTaskName(taskName)) {
        throw Exception('Tên task không hợp lệ');
      }

      final taskId = _firebaseService.getTasksRef().push().key!;

      final customTask = TaskModel(
        id: taskId,
        name: taskName.trim(),
        isDefault: false,
        createdBy: createdBy,
        createdDate: AppDateUtils.getCurrentDate(),
      );

      final userTask = UserTaskModel(
        taskId: taskId,
        userId: userId,
        completed: false,
        completedDate: '',
      );

      final Map<String, dynamic> updates = {
        '${FirebaseConstants.tasksPath}/$taskId': customTask.toMap(),
        '${FirebaseConstants.userTasksPath}/$userId/$taskId': userTask.toMap(),
      };

      await _firebaseService.database.update(updates);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi tạo custom user task: ${e.toString()}');
    }
  }
}
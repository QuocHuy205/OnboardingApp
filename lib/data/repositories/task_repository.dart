import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:onboardingapp/data/models/task_model.dart';
import '../services/firebase_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/utils/validation_utils.dart';
import '../../core/utils/date_utils.dart';

class TaskRepository extends GetxService {
  final FirebaseService _firebaseService = Get.find();

  // Initialize default tasks
  Future<void> initializeDefaultTasks() async {
    try {
      final snapshot = await _firebaseService.getTasksRef()
          .orderByChild('default')
          .equalTo(true)
          .get();

      if (!snapshot.exists) {
        final Map<String, dynamic> updates = {};

        for (final taskName in AppConstants.defaultTaskNames) {
          final taskId = _firebaseService.getTasksRef().push().key!;
          final task = TaskModel(
            id: taskId,
            name: taskName,
            isDefault: true,
            createdBy: 'system',
            createdDate: AppDateUtils.getCurrentDate(),
          );
          updates['${FirebaseConstants.tasksPath}/$taskId'] = task.toMap();
        }

        await _firebaseService.database.update(updates);
      }
    } catch (e) {
      throw Exception('Lỗi khởi tạo default tasks: ${e.toString()}');
    }
  }

  // Get default tasks stream
  Stream<List<TaskModel>> getDefaultTasksStream() {
    return _firebaseService.getTasksRef()
        .orderByChild('default')
        .equalTo(true)
        .onValue
        .map((event) {
      final List<TaskModel> tasks = [];
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final taskData = Map<String, dynamic>.from(value);
          tasks.add(TaskModel.fromMap(taskData));
        });
      }
      return tasks;
    });
  }

  // Get all tasks stream
  Stream<List<TaskModel>> getAllTasksStream() {
    return _firebaseService.getAllTasksStream();
  }

  // Save task
  Future<void> saveTask(TaskModel task) async {
    try {
      await _firebaseService.getTaskRef(task.id).set(task.toMap());
    } catch (e) {
      throw Exception('Lỗi lưu task: ${e.toString()}');
    }
  }

  // Create task
  Future<TaskModel> createTask(String name, bool isDefault, String createdBy) async {
    try {
      if (!ValidationUtils.isValidTaskName(name)) {
        throw Exception('Tên task không hợp lệ');
      }

      final taskId = _firebaseService.getTasksRef().push().key!;
      final task = TaskModel(
        id: taskId,
        name: name.trim(),
        isDefault: isDefault,
        createdBy: createdBy,
        createdDate: AppDateUtils.getCurrentDate(),
      );

      await saveTask(task);
      return task;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi tạo task: ${e.toString()}');
    }
  }

  // Update task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _firebaseService.getTaskRef(task.id).set(task.toMap());
    } catch (e) {
      throw Exception('Lỗi cập nhật task: ${e.toString()}');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firebaseService.getTaskRef(taskId).remove();
      await _deleteAllUserTasksForTask(taskId);
    } catch (e) {
      throw Exception('Lỗi xóa task: ${e.toString()}');
    }
  }

  // Delete custom task for specific user
  Future<void> deleteCustomTaskForUser(String taskId, String userId) async {
    try {
      final Map<String, dynamic> updates = {
        '${FirebaseConstants.tasksPath}/$taskId': null,
        '${FirebaseConstants.userTasksPath}/$userId/$taskId': null,
      };

      await _firebaseService.database.update(updates);
    } catch (e) {
      throw Exception('Lỗi xóa custom task: ${e.toString()}');
    }
  }

  Future<void> _deleteAllUserTasksForTask(String taskId) async {
    try {
      final snapshot = await _firebaseService.getUserTasksRef().get();

      if (snapshot.exists) {
        final Map<String, dynamic> updates = {};
        final data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((userId, userTasks) {
          if (userTasks is Map && userTasks.containsKey(taskId)) {
            updates['${FirebaseConstants.userTasksPath}/$userId/$taskId'] = null;
          }
        });

        if (updates.isNotEmpty) {
          await _firebaseService.database.update(updates);
        }
      }
    } catch (e) {
      // Log error but don't fail main operation
    }
  }
}
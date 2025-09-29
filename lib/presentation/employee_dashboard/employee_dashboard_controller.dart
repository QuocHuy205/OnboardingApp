import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:onboardingapp/core/constants/app_constants.dart';
import 'package:onboardingapp/core/constants/route_constants.dart';
import 'package:onboardingapp/data/models/task_with_user_task.dart';
import 'package:onboardingapp/data/models/user_model.dart';
import 'package:onboardingapp/data/repositories/user_task_repository.dart';

class EmployeeDashboardController extends GetxController {
  final UserTaskRepository _userTaskRepository = Get.find();

  final userTasks = <TaskWithUserTask>[].obs;
  final isLoading = false.obs;
  late final UserModel user;

  StreamSubscription<List<TaskWithUserTask>>? _userTasksSubscription;

  @override
  void onInit() {
    super.onInit();
    user = Get.arguments as UserModel;
    _loadUserTasks();
  }

  @override
  void onClose() {
    _userTasksSubscription?.cancel();
    super.onClose();
  }

  void _loadUserTasks() {
    _userTasksSubscription = _userTaskRepository
        .getUserTasksWithDetailsStream(user.id)
        .listen(
          (tasksList) {
        userTasks.value = tasksList;
      },
      onError: (error) {
        Get.snackbar('Lỗi', 'Không thể tải tasks: $error');
      },
    );
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      final index = userTasks.indexWhere((t) => t.task.id == taskId);
      if (index != -1) {
        final current = userTasks[index];

        final now = DateTime.now();
        final formattedDate = isCompleted
            ? DateFormat('dd/MM/yyyy').format(now)
            : "";

        final updated = TaskWithUserTask(
          task: current.task,
          userTask: current.userTask.copyWith(
            completed: isCompleted,
            completedDate: formattedDate,
          ),
        );
        userTasks[index] = updated;
      }
      await _userTaskRepository.updateTaskStatus(user.id, taskId, isCompleted);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  double get progress {
    if (userTasks.isEmpty) return 0.0;
    final completedCount = userTasks.where((task) => task.userTask.completed).length;
    return completedCount / userTasks.length;
  }

  int get completedCount => userTasks.where((task) => task.userTask.completed).length;

  int get totalCount => userTasks.length;

  bool get isCompleted => progress == AppConstants.progressComplete;

  void logout() {
    Get.offAllNamed(RouteConstants.login);
  }
}
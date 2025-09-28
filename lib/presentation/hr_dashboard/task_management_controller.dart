import 'package:get/get.dart';
import 'dart:async';

import 'package:onboardingapp/data/models/task_model.dart';
import 'package:onboardingapp/data/models/user_model.dart';
import 'package:onboardingapp/data/repositories/task_repository.dart';

class TaskManagementController extends GetxController {
  final TaskRepository _taskRepository = Get.find();

  // Observable variables
  final defaultTasks = <TaskModel>[].obs;
  final isLoading = false.obs;
  final editingTask = Rxn<TaskModel>();
  late final UserModel hrUser;

  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  @override
  void onInit() {
    super.onInit();
    hrUser = Get.arguments as UserModel;
    _loadDefaultTasks();
  }

  @override
  void onClose() {
    _tasksSubscription?.cancel();
    super.onClose();
  }

  void _loadDefaultTasks() {
    _tasksSubscription = _taskRepository.getDefaultTasksStream().listen(
          (tasksList) {
        defaultTasks.value = tasksList;
      },
      onError: (error) {
        Get.snackbar('Lỗi', 'Không thể tải tasks: $error');
      },
    );
  }

  Future<void> createTask(String name, bool isDefault) async {
    if (name.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập tên task');
      return;
    }

    try {
      await _taskRepository.createTask(name, isDefault, hrUser.id);
      Get.snackbar('Thành công', 'Đã tạo task');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskRepository.updateTask(task);
      Get.snackbar('Thành công', 'Đã cập nhật task');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      Get.snackbar('Thành công', 'Đã xóa task');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  void setEditingTask(TaskModel? task) {
    editingTask.value = task;
  }

  void goBack() {
    Get.back();
  }
}
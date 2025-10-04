import 'package:get/get.dart';
import 'package:onboardingapp/core/constants/route_constants.dart';
import 'package:onboardingapp/core/utils/validation_utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:onboardingapp/data/models/task_model.dart';
import 'package:onboardingapp/data/models/task_with_user_task.dart';
import 'package:onboardingapp/data/models/user_model.dart';
import 'package:onboardingapp/data/repositories/task_repository.dart';
import 'package:onboardingapp/data/repositories/user_repository.dart';
import 'package:onboardingapp/data/repositories/user_task_repository.dart';

class HRDashboardController extends GetxController {
  final UserRepository _userRepository = Get.find();
  final UserTaskRepository _userTaskRepository = Get.find();
  final TaskRepository _taskRepository = Get.find();

  final employees = <UserModel>[].obs;
  final isLoading = false.obs;
  late final UserModel hrUser;

  final userTasks = <TaskWithUserTask>[].obs;
  StreamSubscription<List<TaskWithUserTask>>? _tasksSubscription;
  StreamSubscription<List<UserModel>>? _employeesSubscription;

  @override
  void onInit() {
    super.onInit();
    hrUser = Get.arguments as UserModel;
    _loadEmployees();
  }

  @override
  void onClose() {
    _employeesSubscription?.cancel();
    _tasksSubscription?.cancel();
    super.onClose();
  }

  void _loadEmployees() {
    _employeesSubscription = _userRepository.getEmployeesStream().listen(
          (employeeList) {
        employees.value = employeeList;
      },
      onError: (error) {
        Get.snackbar('Lỗi', 'Không thể tải danh sách nhân viên: $error');
      },
    );
  }

  void loadEmployeeTasks(String employeeId) {
    _tasksSubscription?.cancel();
    _tasksSubscription = _userTaskRepository
        .getUserTasksWithDetailsStream(employeeId)
        .listen(
          (tasks) {
        userTasks.assignAll(tasks);
      },
      onError: (e) {
        Get.snackbar('Lỗi', 'Không thể tải tasks: $e');
      },
    );
  }

  Future<void> updateTaskStatus(String employeeId, String taskId, bool isCompleted) async {
    try {
      final index = userTasks.indexWhere((t) => t.task.id == taskId);
      if (index != -1) {
        final current = userTasks[index];
        final updated = TaskWithUserTask(
          task: current.task,
          userTask: current.userTask.copyWith(
            completed: isCompleted,
            completedDate: isCompleted
                ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                : '',
          ),
        );
        userTasks[index] = updated;
      }

      await _userTaskRepository.updateTaskStatus(employeeId, taskId, isCompleted);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  // THÊM PASSWORD PARAMETER
  Future<void> addEmployee(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    isLoading.value = true;

    try {
      final newEmployee = await _userRepository.createEmployee(name, email, password);
      await _userTaskRepository.createUserTasks(newEmployee.id);

      isLoading.value = false;
      Get.back();
      Get.snackbar('Thành công', 'Thêm nhân viên thành công');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updateEmployee(String oldId, String name, String email) async {
    if (name.isEmpty || email.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    isLoading.value = true;

    try {
      final oldEmployee = employees.firstWhere((emp) => emp.id == oldId);
      final updatedEmployee = oldEmployee.copyWith(
        id: ValidationUtils.sanitizeEmailForFirebase(email),
        name: name,
        email: email,
      );

      await _userRepository.updateEmployee(oldId, updatedEmployee);

      isLoading.value = false;
      Get.back();
      Get.snackbar('Thành công', 'Cập nhật thông tin thành công');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteEmployee(UserModel employee) async {
    Get.back(); // Đóng dialog xác nhận ngay

    isLoading.value = true;

    try {
      await _userRepository.deleteEmployee(employee);
      Get.snackbar('Thành công', 'Đã xóa nhân viên ${employee.name}');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCustomTask(String userId, String taskName) async {
    if (taskName.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập tên task');
      return;
    }

    try {
      await _userTaskRepository.createCustomUserTask(userId, taskName, hrUser.id);

      Get.back();
      Get.snackbar('Thành công', 'Đã thêm task riêng');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> editCustomTask(TaskModel task, String newName) async {
    if (newName.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập tên task');
      return;
    }

    try {
      final updatedTask = task.copyWith(name: newName);
      await _taskRepository.updateTask(updatedTask);

      Get.back();
      Get.snackbar('Thành công', 'Đã cập nhật task');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteCustomTask(String taskId, String userId) async {
    Get.back(); // Đóng dialog xác nhận ngay

    try {
      await _taskRepository.deleteCustomTaskForUser(taskId, userId);
      Get.snackbar('Thành công', 'Đã xóa task');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  void navigateToTaskManagement() {
    Get.toNamed(RouteConstants.taskManagement, arguments: hrUser);
  }

  void logout() {
    Get.offAllNamed(RouteConstants.login);
  }
}
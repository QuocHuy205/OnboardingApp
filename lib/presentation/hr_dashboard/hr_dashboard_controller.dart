import 'package:get/get.dart';
import 'package:onboardingapp/core/constants/route_constants.dart';
import 'package:onboardingapp/core/utils/validation_utils.dart';
import 'dart:async';

import 'package:onboardingapp/data/models/task_model.dart';
import 'package:onboardingapp/data/models/user_model.dart';
import 'package:onboardingapp/data/repositories/task_repository.dart';
import 'package:onboardingapp/data/repositories/user_repository.dart';
import 'package:onboardingapp/data/repositories/user_task_repository.dart';

class HRDashboardController extends GetxController {
  final UserRepository _userRepository = Get.find();
  final UserTaskRepository _userTaskRepository = Get.find();
  final TaskRepository _taskRepository = Get.find();

  // Observable variables
  final employees = <UserModel>[].obs;
  final isLoading = false.obs;
  late final UserModel hrUser;

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

  Future<void> addEmployee(String name, String email) async {
    if (name.isEmpty || email.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    isLoading.value = true;

    try {
      final newEmployee = await _userRepository.createEmployee(name, email);
      await _userTaskRepository.createUserTasks(newEmployee.id);

      Get.snackbar('Thành công', 'Thêm nhân viên thành công');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
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
      Get.snackbar('Thành công', 'Cập nhật thông tin thành công');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEmployee(UserModel employee) async {
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
      Get.snackbar('Thành công', 'Đã cập nhật task');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteCustomTask(String taskId, String userId) async {
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../data/models/user_model.dart';
import 'package:onboardingapp/data/models/task_model.dart';
import '../../../data/models/task_with_user_task.dart';
import '../../../data/repositories/user_task_repository.dart';
import '../hr_dashboard_controller.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/text_styles.dart';
import '../../../core/utils/extensions.dart';

class EmployeeProgressDialog extends StatelessWidget {
  final UserModel employee;

  const EmployeeProgressDialog({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: 600.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tiến độ: ${employee.name}',
                          style: AppTextStyles.heading3,
                        ),
                        StreamBuilder<List<TaskWithUserTask>>(
                          stream: Get.find<UserTaskRepository>()
                              .getUserTasksWithDetailsStream(employee.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox.shrink();

                            final tasks = snapshot.data!;
                            final completedCount = tasks.where((t) => t.userTask.completed).length;
                            final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

                            return Text(
                              'Hoàn thành: ${progress.toPercentage}% ($completedCount/${tasks.length})',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.grey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddTaskDialog(context),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: StreamBuilder<List<TaskWithUserTask>>(
                stream: Get.find<UserTaskRepository>()
                    .getUserTasksWithDetailsStream(employee.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator();
                  }

                  final tasks = snapshot.data!;
                  final completedCount = tasks.where((t) => t.userTask.completed).length;
                  final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.lightGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? AppColors.success : AppColors.primary,
                    ),
                  );
                },
              ),
            ),

            // Task List
            Expanded(
              child: StreamBuilder<List<TaskWithUserTask>>(
                stream: Get.find<UserTaskRepository>()
                    .getUserTasksWithDetailsStream(employee.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có tasks nào'));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => SizedBox(height: 4.h),
                    itemBuilder: (context, index) {
                      final taskWithUserTask = snapshot.data![index];
                      return _buildTaskProgressItem(taskWithUserTask);
                    },
                  );
                },
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Đóng'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskProgressItem(TaskWithUserTask taskWithUserTask) {
    final task = taskWithUserTask.task;
    final userTask = taskWithUserTask.userTask;

    return Card(
      color: userTask.completed
          ? AppColors.success.withOpacity(0.1)
          : AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Checkbox(
              value: userTask.completed,
              onChanged: (value) {
                Get.find<UserTaskRepository>()
                    .updateTaskStatus(employee.id, task.id, value ?? false);
              },
              activeColor: AppColors.success,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: userTask.completed ? AppColors.grey : AppColors.onSurface,
                    ),
                  ),
                  if (!task.isDefault) ...[
                    Text(
                      'Task riêng',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                  if (userTask.completed && userTask.completedDate.isNotEmpty) ...[
                    Text(
                      'Hoàn thành: ${userTask.completedDate}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!task.isDefault) ...[
              IconButton(
                onPressed: () => _showEditTaskDialog(context, task),
                icon: const FaIcon(FontAwesomeIcons.pencil, size: 14),
                color: AppColors.primary,
              ),
              IconButton(
                onPressed: () => _showDeleteTaskDialog(context, task),
                icon: const FaIcon(FontAwesomeIcons.trash, size: 14),
                color: AppColors.error,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    final hrController = Get.find<HRDashboardController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm task riêng cho ${employee.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tên task',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                hrController.addCustomTask(employee.id, controller.text);
                Get.back();
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    final controller = TextEditingController(text: task.name);
    final hrController = Get.find<HRDashboardController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tên task',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                hrController.editCustomTask(task, controller.text);
                Get.back();
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTaskDialog(BuildContext context, TaskModel task) {
    final hrController = Get.find<HRDashboardController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa task "${task.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              hrController.deleteCustomTask(task.id, employee.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
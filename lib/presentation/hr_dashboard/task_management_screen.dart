import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'task_management_controller.dart';
import 'package:onboardingapp/data/models/task_model.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';

class TaskManagementScreen extends GetView<TaskManagementController> {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.list, color: AppColors.onPrimary),
            SizedBox(width: 8.w),
            const Text('Quản lý Tasks mặc định'),
          ],
        ),
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm task'),
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: EdgeInsets.all(16.w),
            child: Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasks mặc định',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(() => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${controller.defaultTasks.length}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          // Task List
          Expanded(
            child: Obx(() => controller.defaultTasks.isEmpty
                ? _buildEmptyState()
                : _buildTaskList()),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.clipboardList,
            size: 64.sp,
            color: AppColors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có task mặc định nào',
            style: AppTextStyles.heading3.copyWith(color: AppColors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            'Thêm task đầu tiên để bắt đầu',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: controller.defaultTasks.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final task = controller.defaultTasks[index];
        return _buildTaskManagementItem(task);
      },
    );
  }

  Widget _buildTaskManagementItem(TaskModel task) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: FaIcon(
                FontAwesomeIcons.tasks,
                color: AppColors.primary,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Tạo ngày: ${task.createdDate}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showEditTaskDialog(context, task),
                  icon: const FaIcon(FontAwesomeIcons.pencil),
                  color: AppColors.primary,
                  iconSize: 16.sp,
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, task),
                  icon: const FaIcon(FontAwesomeIcons.trash),
                  color: AppColors.error,
                  iconSize: 16.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Task mới'),
        content: TextField(
          controller: textController,
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
              if (textController.text.isNotEmpty) {
                controller.createTask(textController.text, true);
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
    final textController = TextEditingController(text: task.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa Task'),
        content: TextField(
          controller: textController,
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
              if (textController.text.isNotEmpty) {
                final updatedTask = task.copyWith(name: textController.text);
                controller.updateTask(updatedTask);
                Get.back();
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskModel task) {
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
              controller.deleteTask(task.id);
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

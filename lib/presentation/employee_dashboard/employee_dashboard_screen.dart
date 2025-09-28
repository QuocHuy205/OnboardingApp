import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onboardingapp/presentation/hr_dashboard/widgets/task_item.dart';
import 'employee_dashboard_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';

class EmployeeDashboardScreen extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TodoList',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            Text(
              'Xin chào, ${controller.user.name}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: controller.logout,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.onPrimary),
            ),
            child: const Text('Đăng xuất'),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Obx(() => controller.userTasks.isEmpty
          ? _buildLoadingState()
          : _buildContent()),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Card
          _buildProgressCard(),
          SizedBox(height: 16.h),

          // Task List Header
          Text(
            'Danh sách công việc:',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: 8.h),

          // Task List
          _buildTaskList(),

          // Congratulations Message
          Obx(() => controller.isCompleted
              ? _buildCongratulationsCard()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Obx(() => Card(
      color: controller.isCompleted
          ? AppColors.success.withOpacity(0.1)
          : AppColors.primary.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Onboarding Checklist',
                      style: AppTextStyles.heading3,
                    ),
                    Text(
                      'Tiến độ hoàn thành',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${controller.progress.toPercentage}%',
                  style: AppTextStyles.heading1.copyWith(
                    color: controller.isCompleted ? AppColors.success : AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: controller.progress,
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                controller.isCompleted ? AppColors.success : AppColors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${controller.completedCount}/${controller.totalCount} tasks hoàn thành',
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildTaskList() {
    return Obx(() => ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.userTasks.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final taskWithUserTask = controller.userTasks[index];
        return TaskItem(
          taskWithUserTask: taskWithUserTask,
          onChanged: (value) => controller.updateTaskStatus(
            taskWithUserTask.task.id,
            value ?? false,
          ),
        );
      },
    ));
  }

  Widget _buildCongratulationsCard() {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      child: Card(
        color: AppColors.success.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            '🎉 Chúc mừng! Bạn đã hoàn thành onboarding!',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

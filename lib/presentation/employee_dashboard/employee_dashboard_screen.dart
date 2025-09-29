import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'employee_dashboard_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';
import '../../core/utils/extensions.dart';
import 'widgets/task_item.dart';

class EmployeeDashboardScreen extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade400, Colors.lightBlue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.lightBlue.shade700, size: 28),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "Xin chào, ${controller.user.name}",
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton.icon(
                    onPressed: controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.lightBlue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(
                      "Đăng xuất",
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Obx(
            () => controller.userTasks.isEmpty
            ? _buildLoadingState()
            : _buildContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressCard(),
          SizedBox(height: 20.h),
          Text(
            'Danh sách công việc',
            style: AppTextStyles.heading3.copyWith(
              color: Colors.blueGrey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _buildTaskList(),
          Obx(
                () => controller.isCompleted
                ? _buildCongratulationsCard()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Obx(
          () => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        elevation: 3,
        color: Colors.lightBlue.shade50,
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
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      Text(
                        'Tiến độ hoàn thành',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${controller.progress.toPercentage}%',
                    style: AppTextStyles.heading1.copyWith(
                      color: controller.isCompleted
                          ? Colors.green
                          : Colors.lightBlue.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  minHeight: 10.h,
                  value: controller.progress,
                  backgroundColor: Colors.blue.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.isCompleted ? Colors.green : Colors.lightBlue,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                '${controller.completedCount}/${controller.totalCount} tasks hoàn thành',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(
          () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.userTasks.length,
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          return Obx(() {
            final taskWithUserTask = controller.userTasks[index];
            return TaskItem(
              taskWithUserTask: taskWithUserTask,
              onChanged: (value) => controller.updateTaskStatus(
                taskWithUserTask.task.id,
                value ?? false,
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCongratulationsCard() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        color: Colors.green.shade50,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              const Icon(Icons.celebration, color: Colors.green, size: 28),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Chúc mừng! Bạn đã hoàn thành onboarding 🎉',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

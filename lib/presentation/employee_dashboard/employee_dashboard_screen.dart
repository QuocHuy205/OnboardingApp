import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/route_constants.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';
import '../../core/utils/extensions.dart';
import 'employee_dashboard_controller.dart';
import 'widgets/task_item.dart';

class EmployeeDashboardScreen extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF26C6DA).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.white,
                    child: Text(
                      controller.user.name.isNotEmpty
                          ? controller.user.name[0].toUpperCase()
                          : 'E',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF26C6DA),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // User name
                  Expanded(
                    child: Text(
                      "Xin chào, ${controller.user.name}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Đổi mật khẩu button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      onPressed: () => Get.toNamed(
                        RouteConstants.changePassword,
                        arguments: controller.user,
                      ),
                      icon: const Icon(Icons.lock_reset, color: Colors.white),
                      tooltip: 'Đổi mật khẩu',
                    ),
                  ),
                  SizedBox(width: 4.w),

                  // Logout button
                  ElevatedButton.icon(
                    onPressed: controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF26C6DA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(
                      "Đăng xuất",
                      style: TextStyle(
                        fontSize: 13.sp,
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
              color: const Color(0xFF00838F),
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
        elevation: 6,
        color: Colors.white,
        shadowColor: const Color(0xFF26C6DA).withOpacity(0.1),
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
                          color: const Color(0xFF00838F),
                        ),
                      ),
                      Text(
                        'Tiến độ hoàn thành',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${controller.progress.toPercentage}%',
                    style: AppTextStyles.heading1.copyWith(
                      color: controller.isCompleted
                          ? Colors.green
                          : const Color(0xFF26C6DA),
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
                  backgroundColor: const Color(0xFF4DD0E1).withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      controller.isCompleted ? Colors.green : const Color(0xFF26C6DA)),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                '${controller.completedCount}/${controller.totalCount} tasks hoàn thành',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.grey[700],
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
          final taskWithUserTask = controller.userTasks[index];
          return TaskItem(
            taskWithUserTask: taskWithUserTask,
            onChanged: (value) => controller.updateTaskStatus(
              taskWithUserTask.task.id,
              value ?? false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCongratulationsCard() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        color: Colors.white,
        shadowColor: const Color(0xFF26C6DA).withOpacity(0.1),
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

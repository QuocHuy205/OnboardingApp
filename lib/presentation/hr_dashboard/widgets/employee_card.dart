import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/task_with_user_task.dart';
import '../../../data/repositories/user_task_repository.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/text_styles.dart';
import '../../../core/utils/extensions.dart';

class EmployeeCard extends StatelessWidget {
  final UserModel employee;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskWithUserTask>>(
      stream: Get.find<UserTaskRepository>().getUserTasksWithDetailsStream(employee.id),
      builder: (context, snapshot) {
        double progress = 0.0;
        int completedTasks = 0;
        int totalTasks = 0;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          totalTasks = snapshot.data!.length;
          completedTasks = snapshot.data!.where((task) => task.userTask.completed).length;
          progress = completedTasks / totalTasks;
        }

        return GestureDetector(
          onTap: onTap,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          employee.name.length >= 2
                              ? employee.name.substring(0, 2).toUpperCase()
                              : employee.name.toUpperCase(),
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Employee Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              employee.email,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            Text(
                              'Ngày bắt đầu: ${employee.startDate}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Progress & Actions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${progress.toPercentage}%',
                            style: AppTextStyles.heading2.copyWith(
                              color: progress == 1.0 ? AppColors.success : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: onEdit,
                                icon: const FaIcon(FontAwesomeIcons.pencil),
                                color: AppColors.primary,
                                iconSize: 16.sp,
                              ),
                              IconButton(
                                onPressed: onDelete,
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: AppColors.error,
                                iconSize: 16.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.lightGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Progress Text
                  Text(
                    '$completedTasks/$totalTasks tasks hoàn thành',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
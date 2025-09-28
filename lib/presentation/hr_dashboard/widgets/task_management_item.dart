import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onboardingapp/core/themes/app_colors.dart';
import 'package:onboardingapp/core/themes/text_styles.dart';
import 'package:onboardingapp/data/models/task_model.dart';

class TaskManagementItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLoading;

  const TaskManagementItem({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Task Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.tasks,
                color: AppColors.primary,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Task Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Tạo ngày: ${task.createdDate}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  if (!task.isDefault) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Task riêng',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action Buttons
            if (isLoading) ...[
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ] else ...[
              IconButton(
                onPressed: onEdit,
                icon: const FaIcon(FontAwesomeIcons.pencil),
                color: AppColors.primary,
                iconSize: 16.sp,
                tooltip: 'Sửa task',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const FaIcon(FontAwesomeIcons.trash),
                color: AppColors.error,
                iconSize: 16.sp,
                tooltip: 'Xóa task',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
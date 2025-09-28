import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/task_with_user_task.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/text_styles.dart';

class TaskItem extends StatelessWidget {
  final TaskWithUserTask taskWithUserTask;
  final ValueChanged<bool?> onChanged;

  const TaskItem({
    super.key,
    required this.taskWithUserTask,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final task = taskWithUserTask.task;
    final userTask = taskWithUserTask.userTask;

    return Card(
      color: userTask.completed
          ? AppColors.success.withOpacity(0.1)
          : AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Checkbox(
              value: userTask.completed,
              onChanged: onChanged,
              activeColor: AppColors.success,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: userTask.completed ? AppColors.grey : AppColors.onSurface,
                      decoration: userTask.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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
          ],
        ),
      ),
    );
  }
}

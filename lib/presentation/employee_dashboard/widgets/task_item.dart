import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/task_with_user_task.dart';
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
    final completed = userTask.completed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: completed ? Colors.lightBlue.shade600 : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: completed,
              onChanged: onChanged,
              activeColor: Colors.lightBlue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: completed
                          ? Colors.lightBlue.shade700
                          : Colors.blueGrey.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!task.isDefault)
                    Text(
                      'Task riêng',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.lightBlue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (completed && userTask.completedDate.isNotEmpty)
                    Text(
                      'Hoàn thành: ${userTask.completedDate}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.lightBlue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

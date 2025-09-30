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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26C6DA).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: completed ? const Color(0xFF26C6DA) : Colors.transparent,
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
              activeColor: const Color(0xFF26C6DA),
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
                      color: completed ? const Color(0xFF26C6DA) : const Color(0xFF757575),

                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!task.isDefault)
                    Text(
                      'Task riêng',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF757575),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (completed && userTask.completedDate.isNotEmpty)
                    Text(
                      'Hoàn thành: ${userTask.completedDate}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey[600],
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/task_with_user_task.dart';
import '../../../data/repositories/user_task_repository.dart';

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

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF26C6DA).withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar with gradient
                        Container(
                          width: 56.w,
                          height: 56.h,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              employee.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),

                        // Employee Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00838F),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      employee.email,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Bắt đầu: ${employee.startDate}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Progress percentage
                        Column(
                          children: [
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: progress == 1.0
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFF26C6DA),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '$completedTasks/$totalTasks',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.h,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 1.0
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF26C6DA),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4DD0E1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit),
                            color: const Color(0xFF26C6DA),
                            iconSize: 20.sp,
                            tooltip: 'Chỉnh sửa',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red[400],
                            iconSize: 20.sp,
                            tooltip: 'Xóa',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
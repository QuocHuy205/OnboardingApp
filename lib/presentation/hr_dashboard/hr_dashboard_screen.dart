import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'hr_dashboard_controller.dart';
import 'widgets/employee_card.dart';
import 'widgets/employee_progress_dialog.dart';
import 'package:onboardingapp/data/models/user_model.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';

class HRDashboardScreen extends GetView<HRDashboardController> {
  const HRDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TodoList HR',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            Text(
              'Xin chào, ${controller.hrUser.name}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: controller.navigateToTaskManagement,
            icon: const FaIcon(FontAwesomeIcons.gear),
            tooltip: 'Quản lý Tasks',
          ),
          SizedBox(width: 8.w),
          OutlinedButton(
            onPressed: controller.logout,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.onPrimary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.rightFromBracket, size: 14),
                SizedBox(width: 4.w),
                const Text('Đăng xuất'),
              ],
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEmployeeDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm nhân viên'),
      ),
      body: Obx(() => controller.employees.isEmpty
          ? _buildEmptyState()
          : _buildEmployeesList()),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.users,
            size: 64.sp,
            color: AppColors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có nhân viên nào',
            style: AppTextStyles.heading3.copyWith(color: AppColors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            'Thêm nhân viên đầu tiên để bắt đầu',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.employees.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final employee = controller.employees[index];
        return EmployeeCard(
          employee: employee,
          onTap: () => _showEmployeeProgressDialog(context, employee),
          onEdit: () => _showEditEmployeeDialog(context, employee),
          onDelete: () => _showDeleteConfirmation(context, employee),
        );
      },
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nhân viên mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Họ tên',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
              controller.addEmployee(
                nameController.text,
                emailController.text,
              );
              Get.back();
            },
            child: controller.isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Thêm'),
          )),
        ],
      ),
    );
  }

  void _showEditEmployeeDialog(BuildContext context, UserModel employee) {
    final nameController = TextEditingController(text: employee.name);
    final emailController = TextEditingController(text: employee.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa thông tin nhân viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Họ tên',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
              controller.updateEmployee(
                employee.id,
                nameController.text,
                emailController.text,
              );
              Get.back();
            },
            child: controller.isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Cập nhật'),
          )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa nhân viên ${employee.name}? '
              'Tất cả dữ liệu liên quan sẽ bị xóa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteEmployee(employee);
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

  void _showEmployeeProgressDialog(BuildContext context, UserModel employee) {
    Get.dialog(EmployeeProgressDialog(employee: employee));
  }
}
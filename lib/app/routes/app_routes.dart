import 'package:get/get.dart';
import '../../presentation/change_passworđ/change_password_controller.dart';
import '../../presentation/change_passworđ/change_password_screen.dart';
import '../../presentation/login/login_screen.dart';
import '../../presentation/login/login_controller.dart';
import '../../presentation/forgot_password/forgot_password_screen.dart';
import '../../presentation/forgot_password/forgot_password_controller.dart';
import '../../presentation/hr_dashboard/hr_dashboard_screen.dart';
import '../../presentation/hr_dashboard/hr_dashboard_controller.dart';
import '../../presentation/employee_dashboard/employee_dashboard_screen.dart';
import '../../presentation/employee_dashboard/employee_dashboard_controller.dart';
import '../../presentation/hr_dashboard/task_management_screen.dart';
import '../../presentation/hr_dashboard/task_management_controller.dart';
import '../../core/constants/route_constants.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RouteConstants.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
    ),
    GetPage(
      name: RouteConstants.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: RouteConstants.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ChangePasswordController());
      }),
    ),
    GetPage(
      name: RouteConstants.hrDashboard,
      page: () => const HRDashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HRDashboardController());
      }),
    ),
    GetPage(
      name: RouteConstants.employeeDashboard,
      page: () => const EmployeeDashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => EmployeeDashboardController());
      }),
    ),
    GetPage(
      name: RouteConstants.taskManagement,
      page: () => const TaskManagementScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TaskManagementController());
      }),
    ),
  ];
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onboardingapp/binding/initial_binding.dart';
import 'app/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'core/constants/route_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'TodoList Onboarding',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: RouteConstants.login,
          getPages: AppRoutes.routes,
          initialBinding: InitialBinding(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
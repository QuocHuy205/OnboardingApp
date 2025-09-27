class AppConstants {
  // Roles
  static const String roleEmployee = 'employee';
  static const String roleHR = 'hr';

  // Date format
  static const String dateFormat = 'dd/MM/yyyy';

  // Progress thresholds
  static const double progressComplete = 1.0;

  // Animation durations
  static const int animationDurationShort = 300;
  static const int animationDurationMedium = 500;

  // Default tasks
  static const List<String> defaultTaskNames = [
    'Nhận thẻ nhân viên',
    'Nhận laptop và thiết bị',
    'Setup email công ty',
    'Tham gia group Teams',
    'Đọc employee handbook',
    'Gặp supervisor/mentor',
    'Tour văn phòng',
    'Setup workspace',
    'Hoàn thành giấy tờ',
    'Training cơ bản',
  ];
}
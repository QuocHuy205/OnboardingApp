import 'package:intl/intl.dart';
import 'package:onboardingapp/core/constants/app_constants.dart';

class AppDateUtils {
  static String getCurrentDate() {
    return DateFormat(AppConstants.dateFormat).format(DateTime.now());
  }

  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }
}

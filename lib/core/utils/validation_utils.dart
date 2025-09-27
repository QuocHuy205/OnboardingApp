import 'package:email_validator/email_validator.dart';

class ValidationUtils {
  static bool isValidEmail(String email) {
    return email.isNotEmpty && EmailValidator.validate(email);
  }

  static bool isValidName(String name) {
    return name.isNotEmpty && name.trim().length >= 2;
  }

  static bool isValidTaskName(String taskName) {
    return taskName.isNotEmpty && taskName.trim().length >= 3;
  }

  static String sanitizeEmailForFirebase(String email) {
    return email.replaceAll('@', '_').replaceAll('.', '_');
  }
}
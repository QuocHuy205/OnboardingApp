class UserTaskModel {
  final String taskId;
  final String userId;
  final bool completed;
  final String completedDate;

  UserTaskModel({
    required this.taskId,
    required this.userId,
    required this.completed,
    required this.completedDate,
  });

  factory UserTaskModel.fromMap(Map<String, dynamic> map) {
    return UserTaskModel(
      taskId: map['taskId'] ?? '',
      userId: map['userId'] ?? '',
      completed: map['completed'] ?? false,
      completedDate: map['completedDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'userId': userId,
      'completed': completed,
      'completedDate': completedDate,
    };
  }

  UserTaskModel copyWith({
    String? taskId,
    String? userId,
    bool? completed,
    String? completedDate,
  }) {
    return UserTaskModel(
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      completed: completed ?? this.completed,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserTaskModel &&
        other.taskId == taskId &&
        other.userId == userId &&
        other.completed == completed &&
        other.completedDate == completedDate;
  }

  @override
  int get hashCode {
    return taskId.hashCode ^
    userId.hashCode ^
    completed.hashCode ^
    completedDate.hashCode;
  }
}
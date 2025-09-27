class TaskModel {
  final String id;
  final String name;
  final bool isDefault;
  final String createdBy;
  final String createdDate;

  TaskModel({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.createdBy,
    required this.createdDate,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isDefault: map['default'] ?? true,
      createdBy: map['createdBy'] ?? '',
      createdDate: map['createdDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'default': isDefault,
      'createdBy': createdBy,
      'createdDate': createdDate,
    };
  }

  TaskModel copyWith({
    String? id,
    String? name,
    bool? isDefault,
    String? createdBy,
    String? createdDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.name == name &&
        other.isDefault == isDefault &&
        other.createdBy == createdBy &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    isDefault.hashCode ^
    createdBy.hashCode ^
    createdDate.hashCode;
  }
}

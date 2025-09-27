class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String startDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.startDate,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'employee',
      startDate: map['startDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'startDate': startDate,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? startDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.startDate == startDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    role.hashCode ^
    startDate.hashCode;
  }
}
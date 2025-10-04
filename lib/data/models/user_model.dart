class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String startDate;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.startDate,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'employee',
      startDate: map['startDate'] ?? '',
      password: map['password'] ?? '123456',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'startDate': startDate,
      'password': password,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? startDate,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      password: password ?? this.password,
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
        other.startDate == startDate &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    role.hashCode ^
    startDate.hashCode ^
    password.hashCode;
  }
}
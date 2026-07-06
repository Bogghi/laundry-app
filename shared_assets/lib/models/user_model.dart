enum UserType { owner, employ }

class UserModel {
  final int? id;
  final String username;
  final String passwordHash;
  final UserType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String,
      passwordHash: json['password'] as String,
      type: UserType.values.byName(json['type'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': passwordHash,
      'type': type.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

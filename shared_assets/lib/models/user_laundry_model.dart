enum UserLaundryStatus { pending, approved, rejected }

class UserLaundryModel {
  final int? id;
  final int userId;
  final int laundryId;
  final UserLaundryStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserLaundryModel({
    this.id,
    required this.userId,
    required this.laundryId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLaundryModel.fromJson(Map<String, dynamic> json) {
    return UserLaundryModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      laundryId: json['laundry_id'] as int,
      status: UserLaundryStatus.values.byName(json['status'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'laundry_id': laundryId,
      'status': status.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

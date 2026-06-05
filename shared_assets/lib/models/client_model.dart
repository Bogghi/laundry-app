enum ClientStatus { active, deleted }

class ClientModel {
  final int? id;
  final String name;
  final int phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ClientStatus status;

  ClientModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.status = ClientStatus.active,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as int,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      status: json['status'] != null
          ? ClientStatus.values.byName(json['status'] as String)
          : ClientStatus.active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status.name,
    };
  }
}
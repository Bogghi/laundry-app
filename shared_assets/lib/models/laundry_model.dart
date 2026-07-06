class LaundryModel {
  final int? id;
  final String name;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LaundryModel({
    this.id,
    required this.name,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory LaundryModel.fromJson(Map<String, dynamic> json) {
    return LaundryModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      address: json['address'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

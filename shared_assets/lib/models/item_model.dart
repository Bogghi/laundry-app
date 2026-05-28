class ItemModel {
  final int id;
  final int laundryId;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool deleted;
  final String iconName;

  ItemModel({
    required this.id,
    required this.laundryId,
    required this.name,
    required this.createdAt,
    this.updatedAt,
    this.deleted = false,
    required this.iconName,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      laundryId: json['laundry_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deleted: json['deleted'] as bool? ?? false,
      iconName: json['icon_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'laundry_id': laundryId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted': deleted,
      'icon_name': iconName,
    };
  }
}

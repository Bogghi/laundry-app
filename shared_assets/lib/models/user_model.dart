class UserModel {
  final int id;
  final String name;
  final int phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
    };
  }
}
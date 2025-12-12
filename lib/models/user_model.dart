import 'dart:convert';

class RoleModel {
  final int id;
  final String
      name; // Donor, Recipient, BloodBankManager, Technician, Staff, Admin, MedicalStaff
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleModel(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  RoleModel copyWith(
          {int? id, String? name, DateTime? createdAt, DateTime? updatedAt}) =>
      RoleModel(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json['id'] as int,
        name: json['name'] as String,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final RoleModel role;
  final String? bloodGroup;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.role,
      this.avatarUrl,
      this.bloodGroup,
      this.location,
      required this.createdAt,
      required this.updatedAt});

  UserModel copyWith(
          {int? id,
          String? email,
          String? fullName,
          String? avatarUrl,
          RoleModel? role,
          String? bloodGroup,
          String? location,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        role: role ?? this.role,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        location: location ?? this.location,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        email: json['email'] as String,
        fullName: json['full_name'] as String,
        avatarUrl: json['avatar_url'] as String?,
        role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
        bloodGroup: json['blood_group'] as String?,
        location: json['location'] as String?,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'role': role.toJson(),
        'blood_group': bloodGroup,
        'location': location,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  static String encode(UserModel u) => jsonEncode(u.toJson());
  static UserModel decode(String s) =>
      UserModel.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  AuthTokens({required this.accessToken, required this.refreshToken});
}

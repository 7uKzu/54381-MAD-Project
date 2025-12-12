class NotificationModel {
  final int id;
  final String type; // urgent, info
  final String title;
  final String message;
  final String? bloodGroup;
  final String? location;
  final bool read;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel(
      {required this.id,
      required this.type,
      required this.title,
      required this.message,
      this.bloodGroup,
      this.location,
      required this.read,
      required this.createdAt,
      required this.updatedAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: (json['id'] as num).toInt(),
        type: json['type'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        bloodGroup: json['blood_group'] as String?,
        location: json['location'] as String?,
        read: (json['read'] as bool?) ?? false,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'message': message,
        'blood_group': bloodGroup,
        'location': location,
        'read': read,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

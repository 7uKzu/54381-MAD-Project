class RequestModel {
  final int id;
  final int requesterId;
  final String bloodGroup;
  final String urgency; // normal, high, critical
  final String status; // open, assigned, fulfilled, cancelled
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  RequestModel(
      {required this.id,
      required this.requesterId,
      required this.bloodGroup,
      required this.urgency,
      required this.status,
      this.notes,
      required this.createdAt,
      required this.updatedAt});

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json['id'] as int,
        requesterId: json['requester_id'] as int,
        bloodGroup: json['blood_group'] as String,
        urgency: json['urgency'] as String,
        status: json['status'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'requester_id': requesterId,
        'blood_group': bloodGroup,
        'urgency': urgency,
        'status': status,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class DonationModel {
  final int id;
  final int donorId;
  final String bloodGroup;
  final DateTime donatedAt;
  final String status; // pending, confirmed, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  DonationModel(
      {required this.id,
      required this.donorId,
      required this.bloodGroup,
      required this.donatedAt,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory DonationModel.fromJson(Map<String, dynamic> json) => DonationModel(
        id: json['id'] as int,
        donorId: json['donor_id'] as int,
        bloodGroup: json['blood_group'] as String,
        donatedAt: DateTime.parse(json['donated_at'] as String),
        status: json['status'] as String,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'donor_id': donorId,
        'blood_group': bloodGroup,
        'donated_at': donatedAt.toIso8601String(),
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

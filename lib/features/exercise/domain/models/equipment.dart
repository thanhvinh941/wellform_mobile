class Equipment {
  final String id;
  final String keyCode;
  const Equipment({required this.id, required this.keyCode});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    id: json['id'].toString(),
    keyCode: json['keyCode'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'keyCode': keyCode};
}
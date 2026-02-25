class Equipment {
  final String id;
  final String keyText;
  const Equipment({required this.id, required this.keyText});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    id: json['id'].toString(),
    keyText: json['keyText'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'keyText': keyText};
}
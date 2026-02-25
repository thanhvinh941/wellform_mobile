class FocusArea {
  final String id;
  final String keyCode;
  const FocusArea({required this.id, required this.keyCode});

  factory FocusArea.fromJson(Map<String, dynamic> json) => FocusArea(
    id: json['id'].toString(),
    keyCode: json['keyCode'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'keyCode': keyCode};
}

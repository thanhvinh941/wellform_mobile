class FocusArea {
  final String id;
  final String keyText;
  const FocusArea({required this.id, required this.keyText});

  factory FocusArea.fromJson(Map<String, dynamic> json) => FocusArea(
    id: json['id'].toString(),
    keyText: json['keyText'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'keyText': keyText};
}

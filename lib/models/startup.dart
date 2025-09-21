import 'dart:typed_data';
import 'dart:convert';

class Startup {
  final String id;
  final String name;
  final String websiteUrl;
  final String gifPath; // For web, this will be a base64 encoded string
  final String? gifFileName;
  final DateTime createdAt;
  final bool isUserSubmitted;

  Startup({
    required this.id,
    required this.name,
    required this.websiteUrl,
    required this.gifPath,
    this.gifFileName,
    required this.createdAt,
    this.isUserSubmitted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'websiteUrl': websiteUrl,
    'gifPath': gifPath,
    'gifFileName': gifFileName,
    'createdAt': createdAt.toIso8601String(),
    'isUserSubmitted': isUserSubmitted,
  };

  factory Startup.fromJson(Map<String, dynamic> json) => Startup(
    id: json['id'],
    name: json['name'],
    websiteUrl: json['websiteUrl'],
    gifPath: json['gifPath'],
    gifFileName: json['gifFileName'],
    createdAt: DateTime.parse(json['createdAt']),
    isUserSubmitted: json['isUserSubmitted'] ?? false,
  );

  // Helper method to convert bytes to base64 for web storage
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  // Helper method to convert base64 back to bytes
  static Uint8List base64ToBytes(String base64String) {
    return base64Decode(base64String);
  }

  Startup copyWith({
    String? id,
    String? name,
    String? websiteUrl,
    String? gifPath,
    DateTime? createdAt,
    bool? isUserSubmitted,
  }) {
    return Startup(
      id: id ?? this.id,
      name: name ?? this.name,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      gifPath: gifPath ?? this.gifPath,
      createdAt: createdAt ?? this.createdAt,
      isUserSubmitted: isUserSubmitted ?? this.isUserSubmitted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Startup &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Startup{id: $id, name: $name, websiteUrl: $websiteUrl, gifPath: $gifPath, createdAt: $createdAt, isUserSubmitted: $isUserSubmitted}';
  }
}
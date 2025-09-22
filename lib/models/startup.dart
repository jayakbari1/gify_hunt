import 'dart:typed_data';
import 'dart:convert';

import '../models/gif_data_dm.dart';

class Startup {
  final String id;
  final String name;
  final String websiteUrl;
  final String gifPath; // For web, this will be a base64 encoded string
  final String? gifFileName;
  final DateTime createdAt;
  final bool isUserSubmitted;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? notificationMessage;
  final String? userId;

  Startup({
    required this.id,
    required this.name,
    required this.websiteUrl,
    required this.gifPath,
    this.gifFileName,
    required this.createdAt,
    this.isUserSubmitted = false,
    this.status = 'approved', // Default for static data
    this.submittedAt,
    this.reviewedAt,
    this.notificationMessage,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'websiteUrl': websiteUrl,
    'gifPath': gifPath,
    'gifFileName': gifFileName,
    'createdAt': createdAt.toIso8601String(),
    'isUserSubmitted': isUserSubmitted,
    'status': status,
    'submittedAt': submittedAt?.toIso8601String(),
    'reviewedAt': reviewedAt?.toIso8601String(),
    'notificationMessage': notificationMessage,
    'userId': userId,
  };

  factory Startup.fromJson(Map<String, dynamic> json) => Startup(
    id: json['id'],
    name: json['name'],
    websiteUrl: json['websiteUrl'],
    gifPath: json['gifPath'],
    gifFileName: json['gifFileName'],
    createdAt: DateTime.parse(json['createdAt']),
    isUserSubmitted: json['isUserSubmitted'] ?? false,
    status: json['status'],
    submittedAt: json['submittedAt'] != null ? DateTime.parse(json['submittedAt']) : null,
    reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt']) : null,
    notificationMessage: json['notificationMessage'],
    userId: json['userId'],
  );

  factory Startup.fromGifDataDm(GifDataDm dm) => Startup(
    id: dm.id.toString(),
    name: dm.businessName,
    websiteUrl: dm.websiteUrl ?? '',
    gifPath: dm.gifPath,
    gifFileName: dm.gifName,
    createdAt: dm.createdAt,
    isUserSubmitted: dm.isUserSubmitted,
    status: 'approved', // dummy data is approved
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
    String? gifFileName,
    DateTime? createdAt,
    bool? isUserSubmitted,
    String? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? notificationMessage,
    String? userId,
  }) {
    return Startup(
      id: id ?? this.id,
      name: name ?? this.name,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      gifPath: gifPath ?? this.gifPath,
      gifFileName: gifFileName ?? this.gifFileName,
      createdAt: createdAt ?? this.createdAt,
      isUserSubmitted: isUserSubmitted ?? this.isUserSubmitted,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      notificationMessage: notificationMessage ?? this.notificationMessage,
      userId: userId ?? this.userId,
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
    return 'Startup{id: $id, name: $name, websiteUrl: $websiteUrl, gifPath: $gifPath, createdAt: $createdAt, isUserSubmitted: $isUserSubmitted, status: $status, submittedAt: $submittedAt, reviewedAt: $reviewedAt, notificationMessage: $notificationMessage, userId: $userId}';
  }
}
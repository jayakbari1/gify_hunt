import 'package:json_annotation/json_annotation.dart';

part 'gif_data_dm.g.dart';

@JsonSerializable()
class GifDataDm {
  final int id;
  final String gifName;
  final String businessName;
  final String? websiteUrl;
  final String? description;
  final String gifPath;
  final bool isUserSubmitted;
  final DateTime createdAt;

  const GifDataDm({
    required this.id,
    required this.gifName,
    required this.businessName,
    this.websiteUrl,
    this.description,
    required this.gifPath,
    this.isUserSubmitted = false,
    required this.createdAt,
  });

  factory GifDataDm.fromJson(Map<String, dynamic> json) => _$GifDataDmFromJson(json);
  Map<String, dynamic> toJson() => _$GifDataDmToJson(this);

  GifDataDm copyWith({
    int? id,
    String? gifName,
    String? businessName,
    String? websiteUrl,
    String? description,
    String? gifPath,
    bool? isUserSubmitted,
    DateTime? createdAt,
  }) {
    return GifDataDm(
      id: id ?? this.id,
      gifName: gifName ?? this.gifName,
      businessName: businessName ?? this.businessName,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      description: description ?? this.description,
      gifPath: gifPath ?? this.gifPath,
      isUserSubmitted: isUserSubmitted ?? this.isUserSubmitted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GifDataDm &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GifDataDm{id: $id, gifName: $gifName, businessName: $businessName, websiteUrl: $websiteUrl, isUserSubmitted: $isUserSubmitted}';
  }
}
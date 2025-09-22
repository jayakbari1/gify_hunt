// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_data_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifDataDm _$GifDataDmFromJson(Map<String, dynamic> json) => GifDataDm(
      id: (json['id'] as num).toInt(),
      gifName: json['gifName'] as String,
      businessName: json['businessName'] as String,
      websiteUrl: json['websiteUrl'] as String?,
      description: json['description'] as String?,
      gifPath: json['gifPath'] as String,
      isUserSubmitted: json['isUserSubmitted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GifDataDmToJson(GifDataDm instance) => <String, dynamic>{
      'id': instance.id,
      'gifName': instance.gifName,
      'businessName': instance.businessName,
      'websiteUrl': instance.websiteUrl,
      'description': instance.description,
      'gifPath': instance.gifPath,
      'isUserSubmitted': instance.isUserSubmitted,
      'createdAt': instance.createdAt.toIso8601String(),
    };

import 'package:flutter/material.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.createdAt,
    this.avatarEmoji = '🧪',
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String avatarEmoji;

  UserProfile copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? avatarEmoji,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../db_models/category.dart';

class Category extends Equatable {
  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory Category.fromEntity(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      color: Color(entity.color),
      icon: entity.icon,
    );
  }

  final int id;
  final String name;
  final Color color;
  final int icon;

  @override
  List<Object?> get props => [id, name, color, icon];

  CategoryEntity toEntity() {
    return CategoryEntity(
      name: name,
      color: color.value,
      icon: icon,
      id: id,
    );
  }

  Category copyWith({
    int? id,
    String? name,
    Color? color,
    int? icon,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}

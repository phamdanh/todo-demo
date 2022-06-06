import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';
@JsonSerializable()
class Task {
  static const String idField = 'id';
  static const String nameField = 'name';
  static const String descriptionField = 'description';
  static const String completedField = 'completed';
  final int id;
  final String name;
  final String description;
  ///1: completed, 0: incomplete
  int completed;

  Task({required this.id, required this.name, required this.description, this.completed = 0});
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

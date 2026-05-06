import 'package:hive/hive.dart';

part 'responder_model.g.dart';

@HiveType(typeId: 4)
class ResponderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final bool isAvailable;

  ResponderModel({
    required this.id,
    required this.name,
    required this.role,
    this.isAvailable = true,
  });
}

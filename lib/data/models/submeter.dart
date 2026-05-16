import 'package:hive_ce/hive.dart';

part 'submeter.g.dart';

@HiveType(typeId: 0)
class Submeter extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final String tenantId;

  @HiveField(4)
  final String lastReading;

  @HiveField(5)
  final String status;

  Submeter({
    required this.id,
    required this.unit,
    required this.tenantId,
    required this.lastReading,
    required this.status,
  });
}

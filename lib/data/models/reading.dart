import 'package:hive_ce/hive.dart';

part 'reading.g.dart';

@HiveType(typeId: 1)
class Reading extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String submeterId;

  @HiveField(2)
  final double value;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(5)
  final double balance;

  Reading({
    required this.id,
    required this.submeterId,
    required this.value,
    required this.timestamp,
    this.balance = 0.0,
  });
}

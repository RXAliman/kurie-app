import 'package:hive_ce/hive.dart';

part 'bill.g.dart';

@HiveType(typeId: 2)
class Bill extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String month;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final double kwh;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime timestamp;

  Bill({
    required this.id,
    required this.month,
    required this.amount,
    required this.kwh,
    required this.status,
    required this.timestamp,
  });
}

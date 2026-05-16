import 'package:hive_ce/hive.dart';

part 'bill.g.dart';

@HiveType(typeId: 2)
class Bill extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String submeterId;

  @HiveField(2)
  final String month;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final double kwh;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final double? previousReading;

  @HiveField(8)
  final double? currentReading;

  @HiveField(9)
  final double balance;

  Bill({
    required this.id,
    required this.submeterId,
    required this.month,
    required this.amount,
    required this.kwh,
    required this.status,
    required this.timestamp,
    this.previousReading,
    this.currentReading,
    this.balance = 0.0,
  });
}
